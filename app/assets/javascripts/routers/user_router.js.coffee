class App.Routers.User extends Backbone.Router

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
