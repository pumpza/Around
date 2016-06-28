'use strict'
angular.module 'aroundApp'
.controller 'PlaceCreateCtrl', ($scope, $http, socket, Auth) ->
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
    console.log $scope.place
    $http.post('/api/places', {data: $scope.place, image: $scope.imageUpload}).success (place) ->
      console.log place

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

  $scope.$on 'mapInitialized', (event, map) ->

    navigator.geolocation.getCurrentPosition (position) ->
      c = position.coords
      $scope.place.lat = c.latitude
      $scope.place.lon = c.longitude
      $scope.positions.push
        lat: c.latitude
        lng: c.longitude
      $scope.$apply()

    input = document.getElementById('pac-input')
    searchBox = new (google.maps.places.SearchBox)(input)
    map.controls[google.maps.ControlPosition.TOP_LEFT].push input
    map.addListener 'bounds_changed', ->
      searchBox.setBounds map.getBounds()
      return
    searchBox.addListener 'places_changed', ->
      places = searchBox.getPlaces()
      if places.length == 0
        return
      bounds = new (google.maps.LatLngBounds)
      places.forEach (place) ->
        icon =
          url: place.icon
          size: new (google.maps.Size)(71, 71)
          origin: new (google.maps.Point)(0, 0)
          anchor: new (google.maps.Point)(17, 34)
          scaledSize: new (google.maps.Size)(25, 25)
        # Create a marker for each place.
        $scope.positions.push new (google.maps.Marker)(
          map: map
          icon: icon
          title: place.name
          position: place.geometry.location)
        $scope.place.lat = place.geometry.location.H
        $scope.place.lon = place.geometry.location.L
        $scope.$apply()
        if place.geometry.viewport
          # Only geocodes have viewport.
          bounds.union place.geometry.viewport
        else
          bounds.extend place.geometry.location
        return
      map.fitBounds bounds
      return
    return

  $scope.placeMarker = (e) ->
    $scope.positions = []
    ll = e.latLng
    $scope.place.lat = ll.lat()
    $scope.place.lon = ll.lng()
    $scope.positions.push
      lat: ll.lat()
      lng: ll.lng()
    return
