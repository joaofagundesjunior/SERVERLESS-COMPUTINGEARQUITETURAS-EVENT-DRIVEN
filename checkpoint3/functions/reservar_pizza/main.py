import functions_framework
import json

@functions_framework.http
def reservar_pizza(request):
    request_json = request.get_json(silent=True)
    if not request_json or 'order_id' not in request_json:
        return json.dumps({"error": "Missing order_id"}), 400
    
    print(f"Reservando ingredientes para o pedido {request_json['order_id']}")
    return json.dumps({"status": "reserved", "order_id": request_json['order_id']}), 200
