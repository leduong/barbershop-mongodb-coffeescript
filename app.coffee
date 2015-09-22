'use strict'
# Module dependencies.
fs = require('fs')
express = require('express')
bodyParser = require('body-parser')
errorhandler = require('errorhandler')
methodOverride = require('method-override')
morgan = require('morgan')
path = require('path')
# Connect to database
db = require('./config/db')
# Bootstrap models
modelsPath = path.join(__dirname, 'models')
fs.readdirSync(modelsPath).forEach (file) ->
  require modelsPath + '/' + file
  return
app = express()
port = process.env.PORT or 3000
env = process.env.NODE_ENV or 'development'
if 'development' == env
  app.use morgan('dev')
  app.use errorhandler(
    dumpExceptions: true
    showStack: true)
  app.set 'view options', pretty: true
if 'test' == env
  app.use morgan('test')
  app.set 'view options', pretty: true
  app.use errorhandler(
    dumpExceptions: true
    showStack: true)
if 'production' == env
  app.use morgan()
  app.use errorhandler(
    dumpExceptions: false
    showStack: false)
# all environments
app.set 'port', port
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use morgan('dev')
app.use bodyParser()
app.use methodOverride()
app.use express.static(path.join(__dirname, 'public'))
# Bootstrap routes/api
routesPath = path.join(__dirname, 'routes')
fs.readdirSync(routesPath).forEach (file) ->
  require(routesPath + '/' + file) app
  return
# Start server
app.listen port, ->
  console.log 'Express server listening on port %d in %s mode', port, env
  return
