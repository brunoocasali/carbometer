window.Carbometer =
  Router: {}
  View: {}
  Model: {}
  Collection: {}
  Helper: {}

  initialize: ->
    Carbometer.DashboardRouter = new Carbometer.Router.Dashboard

    Backbone.history.start
      pushState: true

$ ->
  Carbometer.initialize()
