function staticLocalFile(id, callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/cast.json', function (err, data) {
    if(err) throw err;
    
    data = JSON.parse(data);

    callback(data.cast);
  });
}

var fetch = function(id, callback) {
  staticLocalFile(id, callback);
}

exports.cast_data_source = fetch;