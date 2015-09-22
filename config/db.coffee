'use strict'
mongoose = require('mongoose')
config = 
  'db': 'myDb'
  'host': 'localhost'
  'user': ''
  'pw': ''
  'port': 27017
port = if config.port.length > 0 then ':' + config.port else ''
login = if config.user.length > 0 then config.user + ':' + config.pw + '@' else ''
uristring = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or 'mongodb://' + login + config.host + port + '/' + config.db
mongoOptions = db: safe: true
# Connect to Database
mongoose.connect uristring, mongoOptions, (err, res) ->
  if err
    console.log 'ERROR connecting to: ' + uristring + '. ' + err
  else
    console.log 'Successfully connected to: ' + uristring
  return
exports.mongoose = mongoose
