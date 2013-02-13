class App.Routers.Item extends Backbone.Router
  routes:
    'items/new': 'create'

  create: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      App.items.fetch success: =>
        view = new App.Views.ItemCreate()
        App.setAndRenderContentViews([view], true)
        return this
    else
      Backbone.history.navigate('home', trigger: true)
    this