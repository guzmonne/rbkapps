class App.Routers.User extends Backbone.Router

  initialize: ->
    #@user = new App.Models.User()
    #@user.set('id',$.cookie('user_id'))

  routes:
    'home': 'show'
    'users/new': 'create'

  show: ->
    view = new App.Views.UserShow(model: App.user)
    App.setAndRenderContentViews([view])
    this

  create: ->
    view = new App.Views.UserCreate()
    App.setAndRenderContentViews([view])
    this


