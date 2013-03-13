class App.Routers.Item extends Backbone.Router
  routes:
    'items/new': 'create'
    'items/index': 'index'

  create: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.ItemCreate()
      App.setAndRenderContentViews([view])
      return this
    else
      Backbone.history.navigate('home', trigger: true)
    this

  index: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.ItemIndex()
      App.setAndRenderContentViews([view])
      return this
    else
      Backbone.history.navigate('home', trigger: true)
      return this
