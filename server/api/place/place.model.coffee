'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

PlaceSchema = new Schema
  name:     String
  menu:     []
  open_at:  Date
  close_at: Date
  lat:      String
  lon:      String
  image:    String
  phone:    String
  created_by: {}
  note:     String

module.exports = mongoose.model 'Place', PlaceSchema
