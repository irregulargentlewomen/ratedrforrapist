function staticLocalFile(title, callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/titles.json', function (err, data) {
    if(err) throw err;
    
    callback(data);
  });
}

function apiCall(title, callback) {
  var http = require('http');
  var apiConfig = require('./api_config.json');
  var querystring = require('querystring');


  var query = querystring.stringify({
    api_key: apiConfig.key,
    query: title
  })
  var path = '/3/search/movie?' + query;
  http.get(
    {
      host:'api.themoviedb.org',
      path: path,
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

var fetch = function(title, callback) {
  apiCall(title, function(data) {
    callback(JSON.parse(data).results);
  });
}

exports.title_data_source = fetch;