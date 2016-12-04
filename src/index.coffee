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

app.get '/', (req, res) -> res.redirect '/display'

app.get '/display', (req, res) ->
  res.sendFile path.resolve __dirname, 'static', 'display.html'

app.get '/icon.png', (req, res) ->
  res.sendFile path.resolve __dirname, 'static', 'icon.png'

app.get '/startup.png', (req, res) ->
  res.sendFile path.resolve __dirname, 'static', 'startup.png'


# Sockets!
server = http.Server app
io     = socketIO server
io.use require('socket.io-p2p-server').Server

io.on 'connection', (socket) ->
  socket.on 'peer-msg', (data) ->
    socket.broadcast.emit('peer-msg', data)


server.listen (port = parseInt(process.env.PORT) or 8080), ->
  console.log "Listening on #{port}"
