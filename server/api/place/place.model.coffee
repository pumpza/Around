'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

PlaceSchema = new Schema
  name:     String
  menu:     []
  open_at:  Date
  close_at: Date
  lat: String
  lon: String
  image: String
  created_by: {}

module.exports = mongoose.model 'Place', PlaceSchema
