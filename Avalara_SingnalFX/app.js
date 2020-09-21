const express = require('express');
const { response, request } = require('express');
const bodyParser = require('body-parser');
const app = express();
const port =  process.env.port || 8082

app.use(bodyParser.urlencoded({ extended : false }));
app.use(bodyParser.json())
app.use(bodyParser.raw())
app.get('/', (_, response) => {
    response.send('Avalara_DummySingnalFX')
});

app.post('/event', (request, response) => {
    console.log('Got body:', request.body);
    response.sendStatus(200);
});

app.listen(port, () => {
    console.log(`Server is listening on port: ${port}`);
});
