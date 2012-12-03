class Carbometer.Router.Dashboard extends Backbone.Router
  dashboardFrame: null

  routes:
    'dashboard': 'show'

  show: ->
    Carbometer.Posts = new Carbometer.Collection.Posts
    @dashboardFrame = new Carbometer.View.DashboardFrame
    @dashboardFrame.render()
