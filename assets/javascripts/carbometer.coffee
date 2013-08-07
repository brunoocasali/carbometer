window.Carbometer = {}

Carbometer.minWidth = 960
Carbometer.rowHeight = 70

Carbometer.onReady = ->

Carbometer.resizeWidgets = () ->
  if document.documentElement.clientWidth > Carbometer.minWidth
    gridster = Carbometer.gridster.data('gridster')
    if gridster?
      windowWidth = document.documentElement.clientWidth
      cols = Dashing.numColumns
      baseWidth = (windowWidth - (cols * 2) * Dashing.widget_margins[0]) / cols
      baseHeight = baseWidth
      gridster.resize_widget_dimensions({widget_base_dimensions: [baseWidth, baseHeight]})

Carbometer.params = ->
  params = {}
  urlParams = location.search.split '&'
  for param in urlParams
    [paramName, paramValue] = param.split '='
    paramName = paramName.substring(1) if paramName.charAt(0) == '?'
    params[paramName] = paramValue
  params
