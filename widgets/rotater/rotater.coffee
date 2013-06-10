class Dashing.Rotater extends Dashing.Widget

  ready: ->
    @rotationLength = 10000
    @dashboards = [ 'dashboard' ]
    params = Carbometer.params()
    @rotationLength = parseInt(params.rotationLength) if params.rotationLength
    @dashboards = params.dashboards.split(',') if params.dashboards
    @rotateDashboard()

    if @rotationLength > 0 && @dashboards.length > 1
      window.setInterval @rotateDashboard, @rotationLength

  rotateDashboard: =>
    index = @nextDashboardIndex()
    dashboard = @dashboards[index]
    url = "/#{dashboard}#{location.search}"
    node = $(@get 'node')

    node.fadeOut 2000, =>
      @set 'url', url
      node.fadeIn 2000

  nextDashboardIndex: =>
    index = $.cookie().activeDashboardIndex
    if index
      index = parseInt index
      index++

    badIndex = !index || index >= @dashboards.length
    index = 0 if badIndex
    $.cookie 'activeDashboardIndex', "#{index}"
    index