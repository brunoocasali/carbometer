# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

window.Carbometer = {}

Carbometer.minWidth = 960
Carbometer.rowHeight = 225

Carbometer.resizeWidgets = () ->
  if document.documentElement.clientWidth > Carbometer.minWidth
    gridster = Carbometer.gridster.data('gridster')
    windowWidth = document.documentElement.clientWidth
    cols = Dashing.numColumns
    baseWidth = (windowWidth - (cols * 2) * Dashing.widget_margins[0]) / cols
    baseHeight = baseWidth
    gridster.resize_widget_dimensions({widget_base_dimensions: [baseWidth, baseHeight]})

Dashing.on 'ready', ->
  $('.gridster').find('li').not('[data-col]').remove() # Remove weird extra <li> that Dashing adds
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [Carbometer.rowHeight, Carbometer.rowHeight]
  Dashing.numColumns ||= 8

  Batman.setImmediate ->
    Carbometer.gridster = $('.gridster ul:first').gridster
      num_cols: 8
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()

    Carbometer.resizeWidgets()

  $(window).resize =>
    Carbometer.resizeWidgets()
