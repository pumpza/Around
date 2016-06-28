'use strict'

angular.module 'aroundApp'
.controller 'MainCtrl', ($scope, $http, socket) ->
  $scope.awesomeThings = []
  $scope.positions = []
  $scope.places

  $http.get('/api/places').success (places) ->
    $scope.places = places
    for p in $scope.places
      $scope.positions.push
        lat: p.lat
        lng: p.lon

  $scope.addThing = ->
    return if $scope.newThing is ''
    $http.post '/api/things',
      name: $scope.newThing

  $scope.goCreatePlace = () ->
    window.location.href = "/place/create"

    $scope.newThing = ''

  $scope.deleteThing = (thing) ->
    $http.delete '/api/things/' + thing._id

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'

  $scope.$on 'mapInitialized', (event, map) ->
    for p in $scope.places
      $scope.positions.push({lat: p.lat, lon: p.lon})
    $scope.$apply()
