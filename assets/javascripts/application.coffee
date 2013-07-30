# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [Carbometer.rowHeight, Carbometer.rowHeight]
  Dashing.numColumns ||= 16

  Batman.setImmediate ->
    Carbometer.gridster = $('.gridster ul:first').gridster
      num_cols: 16
      num_rows: 9
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()

    Carbometer.resizeWidgets()

  $(window).resize =>
    Carbometer.resizeWidgets()

  Carbometer.onReady()
