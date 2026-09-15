# Hello World Function (Checkpoint 5)

Este projeto demonstra uma Cloud Function (2nd gen) no Google Cloud Platform, utilizando Node.js 22 e uma pipeline de CI/CD automatizada via Cloud Build.

## Estrutura do Projeto

- `index.js`: Lógica principal da função.
- `package.json`: Definição de dependências e scripts.
- `cloudbuild.yaml`: Configuração da pipeline de build e deploy.
- `Dockerfile`: Configuração para containerização (Kaniko).

## Pipeline de Deploy

A pipeline executa os seguintes passos:
1. **Instalação e Testes**: Valida o código Node.js.
2. **Build e Push**: Cria a imagem Docker e a envia para o Artifact Registry.
3. **Deploy**: Atualiza a Cloud Function com a nova versão.

## URL de Acesso
A função está disponível em: `https://us-central1-project-62f09b8b-cbd8-428e-8f5.cloudfunctions.net/hello-world-func`
