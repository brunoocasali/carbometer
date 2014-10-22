class Dashing.Moodio extends Dashing.Widget

  ready: ->
    @vis()

  vis: =>
    ['stampede2.html','stampede.html','earth.html','waves.html'][ parseInt(rand() * 4, 10)]
  
