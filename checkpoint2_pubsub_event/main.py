import base64

def checkpoint2_pubsub_event(event, context):
    """Função disparada por mensagem Pub/Sub."""
    if 'data' in event:
        message = base64.b64decode(event['data']).decode('utf-8')
    else:
        message = 'Mensagem vazia'

    print(f"Mensagem recebida: {message}")
    # Aqui você chama a lógica que estava no checkpoint1
    # Exemplo: processar horário de Brasília
    from datetime import datetime, timezone, timedelta
    brasilia_tz = timezone(timedelta(hours=-3))
    now_brasilia = datetime.now(brasilia_tz)
    print(f"Horário em Brasília: {now_brasilia}")
