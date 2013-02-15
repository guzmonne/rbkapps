class App.Routers.Delivery extends Backbone.Router
  routes:
    'deliveries/new'  : 'create'
    'deliveries/index': 'index'

  create: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      if App.deliveries.length == 0
        App.deliveries.fetch success: =>
          view = new App.Views.DeliveryCreate()
          App.setAndRenderContentViews([view])
          return this
      else
        view = new App.Views.DeliveryCreate()
        App.setAndRenderContentViews([view])
        return this
    else
      Backbone.history.navigate('home', trigger: true)
    this