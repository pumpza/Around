'use strict'

angular.module 'aroundApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'place',
    url: '/place'
    templateUrl: 'app/place/place.html'
    controller: 'PlaceCtrl'
  .state 'createPlace',
    url: '/place/create'
    templateUrl: 'app/place/create/create.html'
    controller: 'PlaceCreateCtrl'
