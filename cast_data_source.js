function staticLocalFile(id, callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/cast.json', function (err, data) {
    if(err) throw err;
    callback(data);
  });
}

function apiCall(id, callback) {
  var http = require('http');
  var apiConfig = require('./api_config.json');
  var querystring = require('querystring');

  http.get(
    'http://api.themoviedb.org/3/movie/'+ id +'/casts?api_key' + apiConfig.key,
    function(response){
      res.on("data", function(chunk) {
        callback(chunk);
      });
  }).on('error', function(e) {
    console.log("Got error: " + e.message);
  });
} 

var fetch = function(id, callback) {
  staticLocalFile(id, function(data) {
    callback(JSON.parse(data).cast);
  });
}

exports.cast_data_source = fetch;