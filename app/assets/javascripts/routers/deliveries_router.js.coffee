class App.Routers.Delivery extends Backbone.Router
  routes:
    'deliveries/new'  : 'create'
    'deliveries/index': 'index'
    'deliveries/:id'  : 'show'

  create: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      if App.items.length == 0
        App.items.fetch success: =>
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

  show: ->
    view = new App.Views.DeliveryShow()
    App.setAndRenderContentViews([view])
    this