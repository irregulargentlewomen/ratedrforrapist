function staticLocalFile(id, callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/cast.json', function (err, data) {
    if(err) throw err;
    callback(data);
  });
}

function apiCall(id, callback) {
  var api_handler = require('./api_handler').api_handler;

  api_handler({
    path: '/3/movie/'+ id +'/casts',
    success: callback
  });
} 

var fetch = function(id, callback) {
  apiCall(id, function(data) {
    callback(JSON.parse(data).cast);
  });
}

exports.cast_data_source = fetch;