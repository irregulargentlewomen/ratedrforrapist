function staticLocalFile(title, callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/titles.json', function (err, data) {
    if(err) throw err;
    
    callback(data);
  });
}

function apiCall(title, callback) {
  var api_handler = require('./api_handler').api_handler;

  api_handler({
    path: '/3/search/movie',
    params: {query: title},
    success: callback
  });
} 

var fetch = function(title, callback) {
  apiCall(title, function(data) {
    callback(JSON.parse(data).results);
  });
}

exports.title_data_source = fetch;