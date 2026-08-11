# Brasília Time Cloud Function

Esta é uma Google Cloud Function simples escrita em Python que retorna o horário atual em Brasília (UTC-3), formatado como `dd/mm/yyyy HH:MM:SS`.

## Estrutura do Repositório

```text
checkpoint1_brasilia_time_function/
├── main.py           # Código fonte da função
├── requirements.txt  # Dependências do Python
├── app_local.py      # Teste local com Flask
├── serverless.yml    # Configuração do Serverless Framework
└── README.md         # Instruções de uso
```

## Como Rodar Localmente (Flask)

Se desejar testar a lógica rapidamente sem o simulador do GCP:
1. `pip install -r requirements.txt`
2. `python app_local.py`
3. Acesse `http://localhost:5000`

## Como Fazer o Deploy (GCP CLI)

1. **Autenticar no GCP:** `gcloud auth login`
2. **Deploy:**
```bash
gcloud functions deploy get_brasilia_time \
  --project project-62f09b8b-cbd8-428e-8f5 \
  --runtime python310 \
  --trigger-http \
  --allow-unauthenticated \
  --region southamerica-east1 \
  --entry-point get_brasilia_time
```

## Como Fazer o Deploy (Serverless Framework)

1. **Instalar Dependências:** `npm install`
2. **Deploy:** `serverless deploy`

## URL de Acesso Pública
👉 [https://get-brasilia-time-dds6lra6za-rj.a.run.app](https://get-brasilia-time-dds6lra6za-rj.a.run.app)

## Exemplo de Resposta
`Horário atual em Brasília: 09/08/2026 14:30:15`
