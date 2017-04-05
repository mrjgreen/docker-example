const app    = require('express')();
const bodyParser = require('body-parser');
const router = require('./router');
const logger = require('bunyan')({name: "Docker API"});
const requestLogger = require('./request-logger')(logger);

app.use(requestLogger);
app.use(bodyParser.json());
app.use(function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
});
app.use('/', router);
app.use(function(req, res, next){
  res.status(404).send({ error: { message: 'Not found', code: 404 }});
  next()
});

router.use(function (err, req, res, next) {
  console.error(err.stack);
  res.status(500).send({ error: { message: 'Something broke', code: 500 }});
});


const port = process.env.LISTEN_PORT || 80;
app.listen(port);
console.log('Docker API started on ' + port);
