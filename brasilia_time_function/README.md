# Brasília Time Cloud Function

Esta é uma Google Cloud Function simples escrita em Python que retorna o horário atual em Brasília (UTC-3), formatado como `dd/mm/yyyy HH:MM:SS`.

## Estrutura do Repositório

```text
brasilia_time_function/
├── main.py           # Código fonte da função
├── requirements.txt  # Dependências do Python
└── README.md         # Instruções de uso
```

## Como Rodar e Fazer o Deploy

### 1. Instalar o Google Cloud SDK
Siga as instruções oficiais para instalar o `gcloud` CLI em sua máquina:
[Instalar Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### 2. Autenticar no GCP
Abra o terminal e execute:
```bash
gcloud auth login
```

### 3. Configurar o Projeto (Opcional)
Se você tiver múltiplos projetos, selecione o desejado:
```bash
gcloud config set project SEU_ID_DO_PROJETO
```

### 4. Fazer o Deploy da Função
Navegue até a pasta do projeto e execute o comando abaixo:
```bash
gcloud functions deploy get_brasilia_time \
  --runtime python310 \
  --trigger-http \
  --allow-unauthenticated \
  --region southamerica-east1
```
*Nota: A região `southamerica-east1` corresponde a São Paulo.*

### 5. Testar a Função
Após o deploy, o comando acima exibirá uma URL (ex: `https://southamerica-east1-seu-projeto.cloudfunctions.net/get_brasilia_time`).

Você pode testar acessando a URL no seu navegador ou via terminal:
```bash
curl https://southamerica-east1-seu-projeto.cloudfunctions.net/get_brasilia_time
```

## Exemplo de Resposta
Ao acessar a função, você verá algo como:
`Horário atual em Brasília: 09/08/2026 14:30:15`

## Entrega Final
Para completar o desafio, certifique-se de incluir:
- O link para este repositório no GitHub.
- A URL pública da função gerada pelo GCP.
- Este README com as instruções.
