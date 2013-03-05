class App.Routers.Delivery extends Backbone.Router
  routes:
    'deliveries/new'  : 'create'
    'deliveries/index': 'index'
    'deliveries/show/:id'  : 'show'

  create: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.DeliveryCreate()
      App.setAndRenderContentViews([view])
      return this
    else
      Backbone.history.navigate('home', trigger: true)
      return this

  index: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.DeliveryIndex()
      App.setAndRenderContentViews([view])
      return this
    else
      Backbone.history.navigate('home', trigger: true)
    this

  show: (id) ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.Loading()
      App.setAndRenderContentViews([view])
      if App.deliveries.length == 0
        App.deliveries.fetch success: =>
          model = App.deliveries.get(id)
          return @showModel(model)
      else
        model = App.deliveries.get(id)
        return @showModel(model)
    else
      Backbone.history.navigate('home', trigger: true)
    this

  showModel: (model) ->
    model.fetchSubCollections success: =>
      view = new App.Views.DeliveryShow(model: model)
      App.setAndRenderContentViews([view])
      return this
