function staticLocalFile(title, callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/titles.json', function (err, data) {
    if(err) throw err;
    
    callback(JSON.parse(data).results);
  });
}

var fetch = function(title, callback) {
  staticLocalFile(title, callback);
}

exports.title_data_source = fetch;