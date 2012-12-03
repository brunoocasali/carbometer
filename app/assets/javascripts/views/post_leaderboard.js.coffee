class Carbometer.View.PostLeaderboard extends Backbone.View
  el: '#post-leaderboard'
  postRows: []

  initialize: ->
    _.bindAll(this, 'add')

    @resetPostRows()
    @collection.bind 'reset', @resetPostRows
    @collection.bind 'reset', @render

  render: =>
    $(@el).children('.post-row').remove()
    _.each @postRows, (row, index) =>
      $(@el).append(row.render())

  resetPostRows: =>
    @postRows = []
    @collection.each(@add)

  add: (post) ->
    postRow = new Carbometer.View.PostRow
      post: post

    @postRows.push postRow
