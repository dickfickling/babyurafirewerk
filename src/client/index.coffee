React     = require 'react'
ReactDOM  = require 'react-dom'
App       = require './views/App'
P2P       = require 'socket.io-p2p'
io        = require 'socket.io-client'


socket = io()

window.p2p = new P2P socket

p2p.on 'ready', ->
  p2p.usePeerConnection = true
  p2p.emit 'peer-obj', { peerId: p2p.peerId }

ReactDOM.render <App p2p={p2p} />, document.body.appendChild document.createElement 'div'
