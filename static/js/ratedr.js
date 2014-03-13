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
    .otherwise({
      redirectTo: '/'
    });
}).factory('Search', ['$resource',
  function($resource){
    return $resource('/search/:title.json', {}, {
      query: {method:'GET', params:{title:'@title'}, isArray:true}
    });
}]).service('Movie', [ '$rootScope', function( $rootScope ) {
  var service = {
    data: {
      19: {
        movie: { id: 19, title: 'Mariel of Redwall', releaseYear: '1865' },
        people: [
          { id: 42, name: 'Maria Giannetti', role: 'typist', blacklistRoles: [
            { role: 'petitioner' },
            { movie: { title: 'Chinatown', releaseYear: '2312'}, role: 'cinematographer'}
            ]
          }
        ]
      }
    },
    getMovieForMovieId: function(id) {
      return service.data[id].movie;
    },
    getPeopleForMovieId: function(id) {
      return service.data[id].people;
    }
  }
  return service;
}]).controller('SearchController', ['$scope', '$routeParams', 'Search', function(scope, routeParams, Search) {
  scope.movies = Search.query({title: routeParams['title']});
}]).controller('MovieController', ['$scope', 'Movie', '$routeParams', function($scope, Movie, routeParams) {
  $scope.movie = Movie.getMovieForMovieId(routeParams['id']);
  $scope.people = Movie.getPeopleForMovieId(routeParams['id']);

  $scope.positiveClass = function() {
    if($scope.people.length > 0) {
      return "active";
    } else {
      return "";
    }
  };
  $scope.negativeClass = function() {
    if($scope.people.length == 0) {
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
