class Dashing.Clock extends Dashing.Widget

  ready: ->
    @startTime()
    setInterval(@startTime, 30 * 1000)

  startTime: =>
    now = moment()
    @set('time', now.format('h:mm'))
    @set('date', now.format('dddd, MMMM D'))