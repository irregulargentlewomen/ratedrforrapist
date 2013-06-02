// JSLint options:
/*global jQuery, $, init */
/*jslint browser: true, white: true, nomen: false, vars: false, plusplus: false */
// Adds js class to html when javascript runs
document.documentElement.className = "js";

// Setting up an Irregular Gentlewomen namespace
var IrregularGentlewomen = IrregularGentlewomen || {};

IrregularGentlewomen.afterSearch = {
    success: function(data) {
        if(data.error) {
            IrregularGentlewomen.afterSearch.error();
        } else if(data.disambiguate) {
            IrregularGentlewomen.populateDisambiguator(data.disambiguate);
            IrregularGentlewomen.pushPageState('state-disambiguate');
        } else if (data.blacklisted) {
            IrregularGentlewomen.populateBlacklist(data.blacklisted_cast_and_crew);
            IrregularGentlewomen.setMovieTitle(data.title);
            IrregularGentlewomen.pushPageState('state-positive');           
        } else {
            IrregularGentlewomen.clearBlacklist();
            IrregularGentlewomen.setMovieTitle(data.title);
            IrregularGentlewomen.pushPageState('state-negative');
        }
    },
    error: function(data) {
        alert('Sorry, we can\'t find what you\'re looking for! Give it another shot.');
    }
};

IrregularGentlewomen.pageStates = [""];

IrregularGentlewomen.pushPageState = function(state) {
    $('body').removeClass(IrregularGentlewomen.pageStates[IrregularGentlewomen.pageStates.length - 1]);
    IrregularGentlewomen.pageStates.push(state);
    $('body').addClass(state);
};

IrregularGentlewomen.popPageState = function() {
    $('body').removeClass(IrregularGentlewomen.pageStates.pop());
    $('body').addClass(IrregularGentlewomen.pageStates[IrregularGentlewomen.pageStates.length - 1]);
}

IrregularGentlewomen.titleSearch = function(form) {
    $.ajax({
        url: form.action + '?' + $(form).serialize(),
        method: 'get',
        success: IrregularGentlewomen.afterSearch.success,
        error: IrregularGentlewomen.afterSearch.error
    });
};

IrregularGentlewomen.castSearch = function(link) {
    $.ajax({
        url: link.href,
        method: 'get',
        success: IrregularGentlewomen.afterSearch.success,
        error: IrregularGentlewomen.afterSearch.error        
    });
    $(link).addClass('selected');
};

IrregularGentlewomen.populateDisambiguator = function(data) {
    IrregularGentlewomen.populateList('.disambiguation', data, function(x) {
        return '<a href="/search?id=' + x.id + '">' + x.title + "</a>"
    });
};

IrregularGentlewomen.populateBlacklist = function(data) {
    IrregularGentlewomen.populateList('.positive.response', data, function(x) {
        var blacklistRoleString = '', m, movieString;

        for(var i = x.blacklist_roles.length - 1; i >= 0; i--) {
            if(x.blacklist_roles[i].movie) {
                m = x.blacklist_roles[i].movie;
                movieString = m.title + ' (' + m.release_year + ') &mdash; ';
            } else {
                movieString = '';
            }
            blacklistRoleString += '<p>' + movieString + x.blacklist_roles[i].role + '</p>';
        }
        return '<h3>' + x.name + ' (' + x.role + ")" + '</h3>' + blacklistRoleString;
    }); 
};

IrregularGentlewomen.clearBlacklist = function() {
    $('.positive.response ul').html(''); 
};

IrregularGentlewomen.populateList = function(listSectionClass, data, stringFunction) {
    var list = $(listSectionClass + ' ul');
    list.html('');
    for(var i = data.length-1; i >= 0; i--) {
        list.append(
            '<li>' + stringFunction(data[i]) + "</li>"
        );
    }
};

IrregularGentlewomen.setMovieTitle = function(title) {
    $('.movie-title').html(title);
}

$(document).ready(function () {
    $('form').submit(function(e){
        e.preventDefault();
        IrregularGentlewomen.titleSearch(e.target);
    });
    $('.disambiguation').on('click', 'li a', function(e){
        e.preventDefault();
        IrregularGentlewomen.castSearch(e.target);
        $('.response .movie-title').html(e.target.innerHTML);
    });
    $('.close').click(function(e) {
        e.preventDefault();
        IrregularGentlewomen.popPageState();
    });
    $('a[href=#further-info]').click(function(e){
        e.preventDefault();
        IrregularGentlewomen.pushPageState('state-further-info');
    });
});