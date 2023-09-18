'use strict';
const express = require('express');

// Constants
const PORT = 5000;
const HOST = '0.0.0.0';

const app = express();

app.set('views', 'views');
app.set('view engine', 'pug');

app.get('/', function(req, res) {
    res.render('home', {
  });
});

app.listen(PORT, HOST, () => {
    console.log(`Running on http://${HOST}:${PORT}`);
});

function signalHandler(signal) {
    console.log(`Received ${signal}. Exiting so long good friend...`)
    process.exit()
}

// kill -SIGINT <pid>
process.on('SIGINT', signalHandler)
process.on('SIGTERM', signalHandler)
process.on('SIGQUIT', signalHandler)
