angular.module('ratedr',
  ['ngRoute', 'ngResource']
).config(function($routeProvider) {
  $routeProvider
    .when('/', {
      controller: 'GlobalController'
    })
    .when('/search/:title', {
      controller: 'SearchController',
      templateUrl: 'disambiguation.html'
    })
    .when('/movies/:id', {
      controller: 'MovieController',
      templateUrl: 'yesorno.html'
    })
    .when('/further-info', {
      templateUrl: 'furtherinfo.html'
    })
    .otherwise({
      redirectTo: '/'
    });
}).factory('Search', ['$resource', function($resource){
    return $resource('/search/:title.json', {}, {
      query: {method:'GET', params:{title:'@title'}, isArray:true}
    });
}]).factory('MovieAndCast', [ '$resource', function( $resource ) {
  return $resource('/movies/:id.json', {}, {
      query: {method:'GET', params:{id:'@id'}}
    });
}]).controller('SearchController', ['$scope', '$routeParams', 'Search', '$location', function(scope, routeParams, Search, $location) {
  scope.movies = Search.query({title: routeParams['title']});
  scope.movies.$promise.then(function() {
    if(scope.movies.length == 1) {
      $location.path('/movies/' + scope.movies[0].id);
    }
  });
}]).controller('MovieController', ['$scope', 'MovieAndCast', '$routeParams', function($scope, MovieAndCast, routeParams) {
  $scope.movie = {};
  $scope.people = [];
  $scope.yes = false;
  $scope.no = false;

  var movieData = MovieAndCast.query({id: routeParams['id']});
  movieData.$promise.then(function() {
    $scope.movie = movieData.movie;
    $scope.people = movieData.people;
    if($scope.people.length == 0) {
      $scope.no = true;
    } else {
      $scope.yes = true;
    }
  })
}]).controller('GlobalController', function($scope, $location){
  $scope.search = function() {
    $location.path('/search/' + $scope.title);
  };
}).directive('sourceLink', function() {
  return {
    restrict: 'A',
    template: "(<a href='{{sourceURL}}' target='_blank'>{{sourceText}}</a>)",
    scope: {
      source: '='
    },
    link: function(scope, elem, attrs) {
      if(scope.source == 'SACD') {
        scope.sourceText = "Société des Auteurs et Compositeurs Dramatiques";
        scope.sourceURL = 'http://www.sacd.fr/Tous-les-signataires-de-la-petition-All-signing-parties.1341.0.html'
      } else if(scope.source == 'BHL') {
        scope.sourceText = 'Bernard-Henri Levy';
        scope.sourceURL = 'http://www.bernard-henri-levy.com/si-vous-souhaitez-signer-la-petition-pour-roman-polanski-2418.html';
      } else {
        scope.sourceText = scope.source;
        scope.sourceURL = scope.source;
      }
    }
  }
});
