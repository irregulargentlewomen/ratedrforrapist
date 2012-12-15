var express = require('express');
var app = express();

app.use('/', express.static(__dirname + '/static/mpaa.html'));

app.use(express.static(__dirname + '/static'));

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.send(500, 'Something broke!');
});

app.listen(4000);
console.log('listening on port 4000');