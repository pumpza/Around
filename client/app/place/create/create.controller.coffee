'use strict'
angular.module 'aroundApp'
.controller 'PlaceCreateCtrl', ($scope, $http, socket, Auth) ->
  $scope.positions = []
  $scope.newTag = ''
  $scope.user = Auth.getCurrentUser()
  $scope.location = {}
  $scope.menus = [{name:'', price: ''}]
  $scope.place = {
    name: ''
    lat: ''
    lon: ''
    open_at: ''
    close_at: ''
    image: ''
    note: ''
    tags: []
    menu: $scope.menus
    created_by: $scope.user || 'guest'
  }

  console.log Auth.getCurrentUser()

  $scope.imageUpload = {name: '', type: '', size: '', path: 'place', data: ''}

  $scope.addMenu = () ->
    $scope.menus.push({name: '', price: ''})

  $scope.removeMenu = (index) ->
    $scope.menus.splice(index, 1)

  $scope.addPlace = ->
    $http.post('/api/places', {data: $scope.place, image: $scope.imageUpload}).success (place) ->
      console.log place
      $scope.resetData()

  $scope.addTag = () ->
    if $scope.place.tags.indexOf($scope.newTag) >= 0
      $scope.newTag = ''
      return
    $scope.place.tags.push($scope.newTag)
    $scope.newTag = ''

  $scope.removeTag = (index) ->
    $scope.place.tags.splice(index, 1)

  $scope.resetData = () ->
    $scope.positions = []
    $scope.user = Auth.getCurrentUser()
    $scope.location = {}
    $scope.menus = [{name:'', price: ''}]
    $scope.place = {
      name: ''
      lat: ''
      lon: ''
      open_at: ''
      close_at: ''
      image: ''
      tags: []
      note: ''
      menu: $scope.menus
      created_by: $scope.user || 'guest'
    }
    $scope.newTag = ''

  $scope.preview = (input) ->
    if input.files and input.files[0]
      reader = new FileReader

      reader.onload = (e) ->
        $('#placePreview').attr 'src', e.target.result
        $scope.imageUpload.data = e.target.result
        $scope.imageUpload.path = 'event/banner'
        return

      reader.readAsDataURL input.files[0]
      $scope.imageUpload.name = input.files[0].name
      $scope.imageUpload.type = input.files[0].type
      $scope.imageUpload.size = input.files[0].size
    return

  $scope.getCurrentPosition = () ->
    $scope.positions = []
    navigator.geolocation.getCurrentPosition (position) ->
      c = position.coords
      $scope.place.lat = c.latitude
      $scope.place.lon = c.longitude
      $scope.positions.push
        lat: c.latitude
        lng: c.longitude
      $scope.$apply()


  $scope.$on 'mapInitialized', (event, map) ->
    $scope.getCurrentPosition()


  $scope.placeMarker = (e) ->
    $scope.positions = []
    ll = e.latLng
    $scope.place.lat = ll.lat()
    $scope.place.lon = ll.lng()
    $scope.positions.push
      lat: ll.lat()
      lng: ll.lng()
    return
