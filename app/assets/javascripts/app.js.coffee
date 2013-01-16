window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  vent: _.extend({}, Backbone.Events)
  user: null

  initialize: ->
    new App.Routers.Nav
    @user = new App.Models.User()
    Backbone.history.start(pushState: true)

  start: ->
    @session = new App.Models.Session()
    if @session.authenticated()
      Backbone.history.navigate('main', trigger = true)
    else
      @navView = new App.Views.Nav(model: @user)
      $('#nav-layout').html(@navView.render().el)
      $('#login-modal').modal('show')


$(document).ready ->
  App.initialize()
  App.start()