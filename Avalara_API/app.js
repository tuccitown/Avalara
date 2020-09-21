const express = require('express');
const { response, request } = require('express');
const http = require('http');
const bodyParser = require('body-parser');
const { json } = require('body-parser');
const e = require('express');
const app = express();
const port =  process.env.port || 8081;
app.use(bodyParser.urlencoded({ extended : false }));
app.use(bodyParser());

app.get('/', (_, response) => {
    response.send('Avalara_API Express App');
});

app.post('/actions', (request, response) => {
    const { id, description } = request.body;
    const eventData = { category: "ALERT", dimensions: {id: id, description: description},eventType: "instance_state_change",timestamp: Date.now() };
    const postData = JSON.stringify(eventData)
    console.log(`POSTDATA: ${postData}`);
    response.json(eventData);
    const options = {
        hostname: 'avalara-sfk',
        port: 8082,
        path: '/event',
        method: 'POST',
        headers: {
            'Content-Type':
             'application/json',
            'Content-Length': Buffer.byteLength(postData),
            'X-SF-Token': 'asdfasdfgasdfgadsfgdafgadfsgadfgadgf'
        }
    };
    const reqPost = http.request(options, (response) => {
        console.log(`STATUS: ${response.statusCode}`);
        //console.log(`HEADERS: ${JSON.stringify(response.headers)}`);
        response.setEncoding('utf8');
        response.on('data', (chunk) => {
            console.log(`BODY: ${chunk}`);
        });
        response.on('end', () => {
            console.log('No more data in response.');
        });
    });
    reqPost.write(postData);
    reqPost.end();
});
app.listen(port, () => {
    console.log(`Server is listening on port: ${port}`);  
});
