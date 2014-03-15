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
  return $resource('/movie/:id.json', {}, {
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
  var movieData = MovieAndCast.query({id: routeParams['id']});
  $scope.movie = function() { return movieData.movie; }
  $scope.people = function() { return movieData.people; }

  $scope.positiveClass = function() {
    if($scope.people() && $scope.people().length > 0) {
      return "active";
    } else {
      return "";
    }
  };
  $scope.negativeClass = function() {
    if($scope.people() && $scope.people().length == 0) {
      return "active";
    } else {
      return "";
    }
  };
}]).controller('GlobalController', function($scope, $location){
  $scope.search = function() {
    $location.path('/search/' + $scope.title);
  };
});
