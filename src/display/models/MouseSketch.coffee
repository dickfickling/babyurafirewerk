Particle = require './Particle'
Sketch = require 'sketch-js'
COLORS = [ '#69D2E7', '#A7DBD8', '#E0E4CC', '#F38630', '#FA6900', '#FF4E50', '#F9D423' ]

module.exports = class MouseSketch

  constructor: (container) ->
    @particles = []
    @sketch = Sketch.create { container: container, autopause: false }

    @sketch.draw = =>
      @draw()
    @sketch.update = =>
      @update()

    @sketch.mousemove = =>
      @mousemove @sketch.touches[0].x, @sketch.touches[0].y

  mousemove: (x, y) =>
    for i in [0..4]
      @spawn x, y


  spawn: (x, y) =>
    if @particles.length > 800
      return

    p = new Particle x, y, 5 + (Math.random() * 35)
    p.wander = 0.5 + Math.random() * 1.5
    p.drag = 0.9 + (Math.random() / 10)
    p.color = COLORS[Math.floor(Math.random() * COLORS.length)]

    force = 2 + Math.random() * 6

    p.vx = Math.sin(p.theta) * force
    p.vy = Math.cos(p.theta) * force

    @particles.push p

  update: =>
    @particles = @particles.filter (p) =>
      p.alive and p.move(@particles.length > 400)


  draw: =>
    @sketch.globalCompositeOperation = 'lighter'
    for p in @particles
      p.draw(@sketch)
