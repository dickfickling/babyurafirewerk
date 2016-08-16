React = require 'react'

module.exports = class App extends React.Component

  @styles:
    main:
      height: '100vh'
      width: '100vw'
      backgroundColor: '#a0a0e0'
      color: 'white'

  constructor: ->
    @state = {}

  click: =>
    @props.p2p.emit 'peer-msg', 'bar click'

  mouseMove: (e) =>
    #if @_lastUpdate and (new Date() - @_lastUpdate) < 150
    #  return
    #@_lastUpdate = new Date()
    percentX = e.clientX / window.innerWidth
    percentY = e.clientY / window.innerHeight
    msg = { x: percentX, y: percentY, type: e.type }
    @props.p2p.emit 'peer-msg', msg

  touch: (e) =>
    msgs = []
    for touch in e.touches
      percentX = touch.clientX / window.innerWidth
      percentY = touch.clientY / window.innerHeight
      msg = { x: percentX, y: percentY, type: e.type }
      msgs.push msg
    @props.p2p.emit 'peer-msg', msgs
    e.preventDefault()

  render: ->
    <div onTouchMove={ @touch } onMouseMove={ @mouseMove } style={ App.styles.main }>
      { JSON.stringify @state.msg }
    </div>
