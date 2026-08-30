locals {
  project_id = "project-62f09b8b-cbd8-428e-8f5"
  region     = "us-central1"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}

# --- Pub/Sub DLQ ---
resource "google_pubsub_topic" "dlq" {
  name = "orders-dlq"
}

# --- Secret Manager ---
resource "google_secret_manager_secret" "payment_api_key" {
  secret_id = "payment-api-key"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "payment_api_key_version" {
  secret      = google_secret_manager_secret.payment_api_key.id
  secret_data = "chave-secreta-de-pagamento-12345"
}

# --- IAM: Service Account para o Workflow ---
resource "google_service_account" "workflow_sa" {
  account_id   = "pizza-workflow-sa"
  display_name = "Service Account for Pizza Workflow"
}

resource "google_project_iam_member" "workflow_invoker" {
  project = local.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

resource "google_project_iam_member" "workflow_pubsub" {
  project = local.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

# --- Storage for Function Source ---
resource "google_storage_bucket" "function_bucket" {
  name                        = "${local.project_id}-functions-src"
  location                    = "US"
  uniform_bucket_level_access = true
}

# --- Zipping and Uploading Functions ---
data "archive_file" "function_zips" {
  for_each    = toset(["reservar_pizza", "cobrar_pagamento", "preparar_pizza", "enviar_pizza", "dead_letter"])
  type        = "zip"
  source_dir  = "${path.module}/../functions/${each.key}"
  output_path = "${path.module}/zips/${each.key}.zip"
}

resource "google_storage_bucket_object" "zip_objects" {
  for_each = data.archive_file.function_zips
  name     = "${each.key}-${each.value.output_md5}.zip"
  bucket   = google_storage_bucket.function_bucket.name
  source   = each.value.output_path
}

# --- IAM: Service Account para as Functions ---
resource "google_service_account" "function_sa" {
  account_id   = "pizza-function-sa"
  display_name = "Service Account for Pizza Cloud Functions"
}

# Permissão para a Function acessar o Secret
resource "google_secret_manager_secret_iam_member" "function_secret_access" {
  secret_id = google_secret_manager_secret.payment_api_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.function_sa.email}"
}

# --- Cloud Functions ---
resource "google_cloudfunctions2_function" "functions" {
  for_each = toset(["reservar_pizza", "cobrar_pagamento", "preparar_pizza", "enviar_pizza"])
  
  name     = each.key
  location = local.region

  build_config {
    runtime     = "python310"
    entry_point = each.key
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.zip_objects[each.key].name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256Mi"
    service_account_email = google_service_account.function_sa.email
    
    dynamic "secret_environment_variables" {
      for_each = each.key == "cobrar_pagamento" ? [1] : []
      content {
        key        = "PAYMENT_API_KEY"
        project_id = local.project_id
        secret     = google_secret_manager_secret.payment_api_key.secret_id
        version    = "latest"
      }
    }
  }

  depends_on = [google_secret_manager_secret_iam_member.function_secret_access]
}

# Dead Letter Function (Pub/Sub Trigger)
resource "google_cloudfunctions2_function" "dead_letter" {
  name     = "dead_letter"
  location = local.region

  build_config {
    runtime     = "python310"
    entry_point = "dead_letter"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.zip_objects["dead_letter"].name
      }
    }
  }

  service_config {
    service_account_email = google_service_account.function_sa.email
  }

  event_trigger {
    trigger_region = local.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.dlq.id
    retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"
  }
}

# --- Cloud Workflow ---
resource "google_workflows_workflow" "pizza_workflow" {
  name            = "pedidos-pizza"
  region          = local.region
  service_account = google_service_account.workflow_sa.id
  
  source_contents = file("${path.module}/../workflows/main_workflow.yaml")

  user_env_vars = {
    RESERVAR_PIZZA_URL     = google_cloudfunctions2_function.functions["reservar_pizza"].service_config[0].uri
    COBRAR_PAGAMENTO_URL   = google_cloudfunctions2_function.functions["cobrar_pagamento"].service_config[0].uri
    PREPARAR_PIZZA_URL     = google_cloudfunctions2_function.functions["preparar_pizza"].service_config[0].uri
    ENVIAR_PIZZA_URL       = google_cloudfunctions2_function.functions["enviar_pizza"].service_config[0].uri
    PROJECT_ID              = local.project_id
  }

  depends_on = [
    google_project_iam_member.workflow_invoker,
    google_project_iam_member.workflow_pubsub,
    google_cloudfunctions2_function.functions
  ]
}

# Remove old IAM resource that used the function email directly
