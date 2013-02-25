class App.Routers.Delivery extends Backbone.Router
  routes:
    'deliveries/new'  : 'create'
    'deliveries/index': 'index'
    'deliveries/show/:id'  : 'show'

  create: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      if App.deliveries.length == 0
        App.deliveries.fetch success: =>
          if App.items.length == 0
            App.items.fetch success: =>
              if App.invoices.length == 0
                App.invoices.fetch success: =>
                  view = new App.Views.DeliveryCreate()
                  App.setAndRenderContentViews([view])
                  return this
              else
                view = new App.Views.DeliveryCreate()
                App.setAndRenderContentViews([view])
                return this
          else
            if App.invoices.length == 0
              App.invoices.fetch success: =>
                view = new App.Views.DeliveryCreate()
                App.setAndRenderContentViews([view])
                return this
            else
              view = new App.Views.DeliveryCreate()
              App.setAndRenderContentViews([view])
              return this
      else
        if App.items.length == 0
          App.items.fetch success: =>
            if App.invoices.length == 0
              App.invoices.fetch success: =>
                view = new App.Views.DeliveryCreate()
                App.setAndRenderContentViews([view])
                return this
            else
              view = new App.Views.DeliveryCreate()
              App.setAndRenderContentViews([view])
              return this
        else
          if App.invoices.length == 0
            App.invoices.fetch success: =>
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
            if App.invoices.length == 0
              App.invoices.fetch success: =>
              if App.items.length == 0
                App.items.fetch success: =>
                  return @showModel(model)
              else
                return @showModel(model)
            else
              if App.items.length == 0
                App.items.fetch success: =>
                  return @showModel(model)
              else
                return @showModel(model)
        else
          model = App.deliveries.get(id)
          if App.invoices.length == 0
            App.invoices.fetch success: =>
            if App.items.length == 0
              App.items.fetch success: =>
                return @showModel(model)
            else
              return @showModel(model)
          else
            if App.items.length == 0
              App.items.fetch success: =>
                return @showModel(model)
            else
              return @showModel(model)
    else
      Backbone.history.navigate('home', trigger: true)
    this

  showModel: (model) ->
    model.fetchSubCollections success: =>
      view = new App.Views.DeliveryShow(model: model)
      App.setAndRenderContentViews([view])
      return this
