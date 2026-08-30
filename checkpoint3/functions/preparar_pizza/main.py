import functions_framework
import json

@functions_framework.http
def preparar_pizza(request):
    request_json = request.get_json(silent=True)
    print(f"Preparando pizza para o pedido {request_json.get('order_id')}")
    return json.dumps({"status": "prepared"}), 200
