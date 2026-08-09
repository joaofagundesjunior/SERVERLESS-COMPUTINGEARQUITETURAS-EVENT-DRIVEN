import functions_framework
from datetime import datetime
import pytz

@functions_framework.http
def get_brasilia_time(request):
    """
    HTTP Cloud Function que retorna o horário atual em Brasília.
    Args:
        request (flask.Request): A requisição HTTP.
    Returns:
        A resposta HTTP formatada.
    """
    # Define o timezone de Brasília (America/Sao_Paulo)
    tz = pytz.timezone('America/Sao_Paulo')
    now = datetime.now(tz)
    
    # Formata a data e hora: dd/mm/yyyy HH:MM:SS
    formatted_time = now.strftime("%d/%m/%Y %H:%M:%S")
    
    return f"Horário atual em Brasília: {formatted_time}\n"
