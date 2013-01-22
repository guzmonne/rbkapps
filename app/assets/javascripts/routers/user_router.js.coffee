class App.Routers.User extends Backbone.Router
  initialize: ->
    @user = new App.Models.User()
    @user.set('id',$.cookie('user_id'))

  routes:
    'home': 'show'

  show: ->
    @user.fetch
      success: =>
        view = new App.Views.UserShow(model: App.user)
        App.setAndRenderContentViews([view])
    this