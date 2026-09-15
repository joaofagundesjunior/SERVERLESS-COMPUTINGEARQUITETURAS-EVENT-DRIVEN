FROM node:22-slim
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE 8080
CMD [ "npx", "@google-cloud/functions-framework", "--target=helloWorld" ]
