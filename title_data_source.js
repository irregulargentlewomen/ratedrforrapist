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

  http.request(
    'http://api.themoviedb.org/3/search/movie?api_key' + apiConfig.key + '&query' + querystring.stringify(title),
    function(response){
      res.on("data", function(chunk) {
        callback(chunk));
      });
  }).on('error', function(e) {
    console.log("Got error: " + e.message);
  });
} 

var fetch = function(title, callback) {
  staticLocalFile(title, function(data) {
    callback(JSON.parse(data).results);
  });
}

exports.title_data_source = fetch;