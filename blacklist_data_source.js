function staticLocalFile(callback) {
  var fs = require('fs');

  fs.readFile(__dirname + '/test/data/blacklist.json', function (err, data) {
    if(err) throw err;
    
    data = JSON.parse(data);

    callback(data);
  });
}

var fetch = function(callback) {
  staticLocalFile(callback);
}

var check = function(people, callback) {
  fetch(function(blacklist){
    var blacklisted = (function(){
      for(var i = people.length - 1; i >= 0; i-- ) {
        if(blacklist.indexOf(people[i].id) >= 0) {
          return true;
        }
      }
      return false;
    }());
    callback(blacklisted);
  });
}

exports.check_blacklist = check;