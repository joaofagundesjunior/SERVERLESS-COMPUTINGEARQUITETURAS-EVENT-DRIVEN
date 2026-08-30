import functions_framework
import json

@functions_framework.http
def enviar_pizza(request):
    request_json = request.get_json(silent=True)
    print(f"Enviando pizza para o pedido {request_json.get('order_id')}")
    return json.dumps({"status": "shipped", "tracking_id": "track_98765"}), 200
