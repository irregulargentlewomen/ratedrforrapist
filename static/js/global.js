// JSLint options:
/*global jQuery, $, init */
/*jslint browser: true, white: true, nomen: false, vars: false, plusplus: false */
// Adds js class to html when javascript runs
document.documentElement.className = "js";

// Setting up an Irregular Gentlewomen namespace
var IrregularGentlewomen = IrregularGentlewomen || {};

IrregularGentlewomen.afterSearch = {
    success: function(data) {
        console.log(data);
        if(data.error) {
            IrregularGentlewomen.afterSearch.error();
        } else if(data.disambiguate) {
            IrregularGentlewomen.populateDisambiguator(data.disambiguate);
        } else if (data.blacklisted) {
    	    $('.positive.response').addClass("invoked");
        } else {
            $('.negative.response').addClass("invoked");
        }
    },
    error: function() {
        alert('try again');
    }
};

IrregularGentlewomen.titleSearch = function(form) {
    $.ajax({
        url: form.action + '?' + $(form).serialize(),
        method: 'get',
        success: IrregularGentlewomen.afterSearch.success,
        error: IrregularGentlewomen.afterSearch.error
    });
}

IrregularGentlewomen.castSearch = function(link) {
    $.ajax({
        url: link.href,
        method: 'get',
        success: IrregularGentlewomen.afterSearch.success,
        error: IrregularGentlewomen.afterSearch.error        
    });
    $(link).addClass('selected');
}

IrregularGentlewomen.populateDisambiguator = function(data) {
    var section = $('.disambiguation'),
        list = section.find('ul');

    list.html('');
    $('body').removeClass("rated-rapist");
    $('body').removeClass("rated-rapist-free"); /* I would really prefer to avoid this language, as we aren't looking at other rape cases (and there are a LOT) in Hollywood */

    for(var i = data.length-1; i >= 0; i--) {
        list.append(
            '<li><a href="/search?id=' +
            data[i].id +
            '">' +
            data[i].title +
            "</a></li>"
        );
    }
    section.addClass('needed');
}

$(document).ready(function () {
    $('form').submit(function(e){
        e.preventDefault();
        IrregularGentlewomen.titleSearch(e.target);
    });
    $('.disambiguation').on('click', 'li a', function(e){
        e.preventDefault();
        IrregularGentlewomen.castSearch(e.target);
    });
});