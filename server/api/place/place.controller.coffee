###*
Using Rails-like standard naming convention for endpoints.
GET     /things              ->  index
POST    /things              ->  create
GET     /things/:id          ->  show
PUT     /things/:id          ->  update
DELETE  /things/:id          ->  destroy
###

'use strict'

_ = require 'lodash'
Place = require './place.model'

# Get list of things
exports.index = (req, res) ->
  Place.find (err, places) ->
    return handleError(res, err)  if err
    res.status(200).json places



# Get a single Place
exports.show = (req, res) ->
  Place.findById req.params.id, (err, place) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless place
    res.json place

# Creates a new Place in the DB.
exports.create = (req, res) ->
  Place.create req.body.data, (err, place) ->
    console.log req.body
    return handleError(res, err)  if err
    console.log req.body.image

    if req.body.image.type == 'image/jpeg'
      base64Data = req.body.image.data.replace(/^data:image\/jpeg;base64,/, '')
      type = 'jpg'
    else
      base64Data = req.body.image.data.replace(/^data:image\/png;base64,/, '')
      type= 'png'

    require('fs').writeFile 'public/images/place/'+place._id+'.'+type, base64Data, 'base64', (err) ->
      console.log err
    res.status(201).json place

# Updates an existing Place in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Place.findById req.params.id, (err, place) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless place
    updated = _.merge(place, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json place

# Deletes a Place from the DB.
exports.destroy = (req, res) ->
  Place.findById req.params.id, (err, place) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless place
    Place.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
