var express = require('express');
var app = express();

app.get('/', function(req, res){
  res.send('Polanski test')
});

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.send(500, 'Something broke!');
});

app.listen(4000);
console.log('listening on port 3000');