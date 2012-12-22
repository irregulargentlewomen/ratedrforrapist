var express = require('express');
var app = express();

var title_data_source = require('./title_data_source');
var exec = require('child_process').exec;


var search = require('./search').search;

app.use('/search', search);

app.use(express.static(__dirname + '/static'));

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.send(500, 'Something broke!');
});

app.listen(4000);
console.log('listening on port 4000');