import functions_framework
import base64
import json

@functions_framework.cloud_event
def dead_letter(cloud_event):
    # Processa falhas vindas do Pub/Sub DLQ
    try:
        data = base64.b64decode(cloud_event.data["message"]["data"]).decode()
        print(f"Falha detectada no processamento: {data}")
    except Exception as e:
        print(f"Erro ao processar DLQ: {e}")
