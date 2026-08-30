import functions_framework
import json
import os

@functions_framework.http
def cobrar_pagamento(request):
    request_json = request.get_json(silent=True)
    idempotency_key = request.headers.get('Idempotency-Key')
    
    # Em um cenário real, usaríamos o Secret Manager SDK.
    # Aqui simulamos que a chave foi injetada via variável de ambiente pelo Terraform.
    api_key = os.environ.get('PAYMENT_API_KEY', 'NOT_SET')
    
    if not request_json or 'amount' not in request_json:
        return json.dumps({"error": "Missing amount"}), 400
    
    print(f"Processando pagamento de R${request_json['amount']} com chave {idempotency_key}")
    return json.dumps({"status": "paid", "transaction_id": "tx_12345"}), 200
