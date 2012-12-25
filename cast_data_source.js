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

  http.get(
    {
      host:'api.themoviedb.org',
      path: '/3/movie/'+ id +'/casts?api_key=' + apiConfig.key,
      port: 80,
      method: 'GET',
      headers: {"Accept": "application/json"}
    },
    function(res) {
      var body = '';
      res.on("data", function(chunk) {
        body += chunk;
      });

      res.on("end", function() {
        console.log(body);
        callback(body);
      });
  }).on('error', function(e) {
    console.log("Got error: " + e.message);
  });
} 

var fetch = function(id, callback) {
  apiCall(id, function(data) {
    callback(JSON.parse(data).cast);
  });
}

exports.cast_data_source = fetch;