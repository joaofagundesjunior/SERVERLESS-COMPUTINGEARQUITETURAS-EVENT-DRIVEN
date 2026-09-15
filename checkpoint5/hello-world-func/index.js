const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  res.send('Olá, Mundo! Deploy automático funcionando v2 🚀');
});
