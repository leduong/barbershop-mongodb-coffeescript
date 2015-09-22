'use strict'
mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
fields = 
  Name: type: String
  Email: type: String
  PreferredBarber: type: String
customerSchema = new Schema(fields)
module.exports = mongoose.model('Customer', customerSchema)
