var searchOnTitle = require('./title_data_source').title_data_source;
var getCast = require('./cast_data_source').cast_data_source;
var checkBlacklist = require('./blacklist_data_source').check_blacklist;

function search(req, res) {
    function titleSearch(title) {
        searchOnTitle(title, function(titleData){
            if(titleData.length == 1) {
                castSearch(titleData[0].id);
            } else {
                res.type('text/json');
                res.send(titleData.map(function(datum) {
                    return {id: datum.id, title: datum.title};
                }));
            }
        });
    }

    function castSearch(id) {
        getCast(id, function(castData) {
            checkBlacklist(castData, function(blacklisted){
                res.type('text/json');
                res.send({blacklisted: blacklisted});
            });
        });
    }

    if(req.query.title) {
        titleSearch(req.query.title);
    } else if (req.query.id) {
        castSearch(req.query.id);
    } else {
        res.type('text/json');
        res.send('{"error": "Please provide valid search params"}')
    }
}

exports.search = search;