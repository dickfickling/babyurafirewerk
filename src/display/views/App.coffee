React = require 'react'
MouseSketch = require '../models/MouseSketch'
#sd = require './sound'

module.exports = class App extends React.Component

  @styles:
    main:
      height: '100vh'
      width: '100vw'
      backgroundColor: '#202030'
      color: 'white'
      cursor: 'none'

  #constructor: ->
  #  @maxFreq = 6000
  #  sd.start(880)

  componentDidMount: ->
    @_sketch = new MouseSketch @refs.container
    @props.p2p.on 'peer-msg', (data) =>
      if typeof data is 'object' and (x = data.x) and (y = data.y)
        @_sketch.mousemove x*window.innerWidth, y*window.innerHeight
        @_sketch.mousemove x*window.innerWidth, (1-y)*window.innerHeight
        @_sketch.mousemove (1-x)*window.innerWidth, (1-y)*window.innerHeight
        @_sketch.mousemove (1-x)*window.innerWidth, y*window.innerHeight
        #@_changeSound data

      else if Array.isArray data
        data.forEach (touch) =>
          @_sketch.mousemove touch.x*window.innerWidth, touch.y*window.innerHeight
          @_sketch.mousemove touch.x*window.innerWidth, (1-touch.y)*window.innerHeight
          @_sketch.mousemove (1-touch.x)*window.innerWidth, (1-touch.y)*window.innerHeight
          @_sketch.mousemove (1-touch.x)*window.innerWidth, touch.y*window.innerHeight
          #@_changeSound touch

  _changeSound: ({x, y}) ->
    console.log 'changin sound', x, y
    px = x / window.innerWidth
    py = y / window.innerHeight
    freq = (py * 1000000)
    distortionAmount = px * 1000000
    sd.changeFrequency freq, distortionAmount, (10 * px)

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
      <div ref="container" />
    </div>

