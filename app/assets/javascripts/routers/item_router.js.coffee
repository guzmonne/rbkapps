class App.Routers.Item extends Backbone.Router
  routes:
    'items/new': 'create'
    'items/index': 'index'

  create: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      if App.items.length == 0
        App.items.fetch success: =>
          view = new App.Views.ItemCreate()
          App.setAndRenderContentViews([view])
          return this
      else
        view = new App.Views.ItemCreate()
        App.setAndRenderContentViews([view])
        return this
    else
      Backbone.history.navigate('home', trigger: true)
    this

  index: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      if App.items.length == 0
        App.items.fetch success: =>
          view = new App.Views.ItemIndex()
          App.setAndRenderContentViews([view])
          return this
      else
        view = new App.Views.ItemIndex()
        App.setAndRenderContentViews([view])
        return this
    else
    Backbone.history.navigate('home', trigger: true)
    this
