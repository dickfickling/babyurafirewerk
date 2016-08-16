Promise             = require 'bluebird'
express             = require 'express'
path                = require 'path'
http                = require 'http'
socketIO            = require 'socket.io'


# Create and initialize express app
app = express()

# Register logging handler, in development mode
if process.env.NODE_ENV is 'development'
  app.use require './middleware/logging-handler'

# Enable webpack reloading of javascript client code
if process.env.NODE_ENV is 'development'
  app.use require('./middleware/webpack-reload')
else
  app.use require('./middleware/webpack-memory')

app.get '/display', (req, res) ->
  res.sendFile path.resolve __dirname, 'static', 'display.html'

app.get '/client', (req, res) ->
  res.sendFile path.resolve __dirname, 'static', 'client.html'


# Sockets!
server = http.Server app
io     = socketIO server
io.use require('socket.io-p2p-server').Server

io.on 'connection', (socket) ->
  socket.on 'peer-msg', (data) ->
    socket.broadcast.emit('peer-msg', data)


server.listen (port = parseInt(process.env.PORT) or 8080), ->
  console.log "Listening on #{port}"
