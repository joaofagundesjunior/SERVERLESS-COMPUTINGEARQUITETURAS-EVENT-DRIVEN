from flask import Flask, request
from main import get_brasilia_time

app = Flask(__name__)

@app.route('/')
def home():
    # Chama a função simulando o comportamento da Cloud Function
    return get_brasilia_time(request)

if __name__ == '__main__':
    print("Servidor local iniciado em http://localhost:5000")
    app.run(debug=True, port=5000)
