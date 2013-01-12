function apiHandler(config) {
  var http = require('http');
  var apiConfig = require('./api_config.json');
  var querystring = require('querystring');

  var params = {api_key: apiConfig.key};
  for(prop in config.params) {
    params[prop] = config.params[prop];
  }

  console.log(config.path + '?' + querystring.stringify(params));

  http.get(
    {
      host:'api.themoviedb.org',
      path: config.path + '?' + querystring.stringify(params),
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
        config.success(body);
      });
  }).on('error', function(e) {
    console.log("Got error: " + e.message);
  });
} 

exports.api_handler = apiHandler;