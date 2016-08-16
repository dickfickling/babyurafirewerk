React = require 'react'
MouseSketch = require '../models/MouseSketch'

module.exports = class App extends React.Component

  @styles:
    main:
      height: '100vh'
      width: '100vw'
      backgroundColor: '#202030'
      color: 'white'

  componentDidMount: ->
    @_sketch = new MouseSketch @refs.container
    @props.p2p.on 'peer-msg', (data) =>
      if typeof data is 'object' and (x = data.x) and (y = data.y)
        @_sketch.mousemove x*window.innerWidth, y*window.innerHeight
      else if Array.isArray data
        data.forEach ({ x, y }) =>
          @_sketch.mousemove x*window.innerWidth, y*window.innerHeight

  render: ->
    <div style={ App.styles.main }>
      <div ref="container" />
    </div>
