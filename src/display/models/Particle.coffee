DAMPING = 0.995

module.exports = class Particle

  constructor: (x, y, radius) ->
    @alive = true
    @radius = radius or 10
    @wander = 0.15
    @theta = Math.random() * Math.PI * 2
    @drag = 0.92
    @color = '#FFF'

    @x = x or 0.0
    @y = y or 0.0
    @vx = 0.0
    @vy = 0.0


  move: (fast) =>
    @x += @vx
    @y += @vy

    @vx *= @drag
    @vy *= @drag

    @theta += (Math.random() - 0.5) * @wander
    @vx += sin(@theta) * 0.1
    @vy += cos(@theta) * 0.1

    if fast
      @radius *= 0.66
      @alive = @radius > 0.5
    else
      @radius *= 0.96
      @alive = @radius > 0.5


  draw: (ctx) =>
    ctx.beginPath()
    ctx.moveTo @x, @y
    ctx.lineTo @x - @radius, @y + @radius * 2
    ctx.lineTo @x + @radius, @y + @radius * 2
    #ctx.arc @x, @y, @radius, 0, Math.PI*2
    ctx.fillStyle = @color
    ctx.fill()
