window.Carbometer = {}

Carbometer.minWidth = 960
Carbometer.rowHeight = 140
Carbometer.rotationLength = 10000
Carbometer.dashboards = [ 'dashboard'
                          'sampletv' ]

Carbometer.onReady = ->
  window.setInterval Carbometer.rotateDashboard, Carbometer.rotationLength

Carbometer.resizeWidgets = () ->
  if document.documentElement.clientWidth > Carbometer.minWidth
    gridster = Carbometer.gridster.data('gridster')
    windowWidth = document.documentElement.clientWidth
    cols = Dashing.numColumns
    baseWidth = (windowWidth - (cols * 2) * Dashing.widget_margins[0]) / cols
    baseHeight = baseWidth
    gridster.resize_widget_dimensions({widget_base_dimensions: [baseWidth, baseHeight]})

Carbometer.nextDashboardIndex = ->
  index = $.cookie().activeDashboardIndex
  if index
    index = parseInt index
    index++

  badIndex = !index || index >= Carbometer.dashboards.length
  index = 0 if badIndex
  $.cookie 'activeDashboardIndex', "#{index}"
  index

Carbometer.rotateDashboard = ->
  index = Carbometer.nextDashboardIndex()
  dashboard = Carbometer.dashboards[index]
  window.location = "/#{dashboard}#{location.search}"
