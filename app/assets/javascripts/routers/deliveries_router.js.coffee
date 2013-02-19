class App.Routers.Delivery extends Backbone.Router
  routes:
    'deliveries/new'  : 'create'
    'deliveries/index': 'index'
    'deliveries/show/:id'  : 'show'

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

  index: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      if App.items.length == 0
        App.items.fetch success: =>
          if App.deliveries.length == 0
            App.deliveries.fetch success: =>
              view = new App.Views.DeliveryIndex()
              App.setAndRenderContentViews([view])
              return this
          else
            view = new App.Views.DeliveryIndex()
            App.setAndRenderContentViews([view])
            return this
      else
        if App.deliveries.length == 0
          App.deliveries.fetch success: =>
          view = new App.Views.DeliveryIndex()
          App.setAndRenderContentViews([view])
          return this
        else
          view = new App.Views.DeliveryIndex()
          App.setAndRenderContentViews([view])
          return this
    else
      Backbone.history.navigate('home', trigger: true)

  show: (id) ->
    if App.user.get("comex") == true or App.user.get("admin") == true
        if App.deliveries.length == 0
          App.deliveries.fetch success: =>
            model = App.deliveries.get(id)
            item = new App.Models.Item()
            item.id = model.get('item_id')
            item.fetch success: =>
              if model.invoices.length == 0
                model.invoices.fetch data: {delivery_id: model.id}, success: =>
                  view = new App.Views.DeliveryShow(model: model, item: item)
                  App.setAndRenderContentViews([view])
                  return this
              else
                view = new App.Views.DeliveryShow(model: model, item: item)
                App.setAndRenderContentViews([view])
                return this
        else
          model = App.deliveries.get(id)
          item = new App.Models.Item()
          item.id = model.get('item_id')
          item.fetch success: =>
            if model.invoices.length == 0
              model.invoices.fetch data: {delivery_id: model.id}, success: =>
                view = new App.Views.DeliveryShow(model: model, item: item)
                App.setAndRenderContentViews([view])
                return this
            else
              view = new App.Views.DeliveryShow(model: model, item: item)
              App.setAndRenderContentViews([view])
              return this
    else
      Backbone.history.navigate('home', trigger: true)
    this
