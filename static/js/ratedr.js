angular.module('ratedr',
  ['ngRoute']
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
}).service('Search', [ '$rootScope', function( $rootScope ) {
  var service = {
    searches: {
      'test search': [
        { id: 19, title: 'Mariel of Redwall', releaseYear: '1865' },
        { id: 23, title: 'Gaudy Night', releaseYear: '1993'}
      ],
      'other search': [
        { id: 54, title: 'Victory', releaseYear: '1231' }
      ]
    },
    getSearchResults: function(title) {
      return service.searches[title];
    }
  }
  return service;
}]).controller('SearchController', ['$scope', 'Search', '$routeParams', function(scope, Search, routeParams) {
  scope.movies = Search.getSearchResults(routeParams['title']);
}]).controller('MovieController', function($scope) {
  $scope.movie = { title: 'Mariel of Redwall', releaseYear: '1865' };
  $scope.people = [
    { id: 42, name: 'Maria Giannetti', role: 'typist', blacklistRoles: [
      { role: 'petitioner' },
      { movie: { title: 'Chinatown', releaseYear: '2312'}, role: 'cinematographer'}
    ] }
  ]
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
}).controller('GlobalController', function($scope, $location){
  $scope.search = function() {
    $location.path('/search/' + $scope.title);
  };
});
