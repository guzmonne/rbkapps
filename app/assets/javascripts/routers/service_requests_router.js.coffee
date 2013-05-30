class App.Routers.ServiceRequests extends Backbone.Router

  initialize: ->
    @listenTo App.vent, "service_requests:show", (model) => @setServiceRequest(model)

  routes:
    'service_requests/index'      : 'index'
    'service_requests/show/:id'   : 'show'
    'service_requests/create'     : 'create'
    'categories/index'            : 'categoriesIndex'

  setServiceRequest: (model) ->
    Backbone.history.navigate "service_requests/show/#{model.get('id')}", trigger = true

  index: ->
    view = new App.Views.ServiceRequestsIndex()
    App.setAndRenderContentViews([view])
    this

  show: (id) ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.serviceRequests.length == 0
      App.serviceRequests.fetch data:{user_id: App.user.id}, success: =>
        model = App.serviceRequests.get(id)
        view = new App.Views.ServiceRequestsShow(model: model)
        App.setAndRenderContentViews([view])
    else
      model = App.serviceRequests.get(id)
      view = new App.Views.ServiceRequestsShow(model: model)
      App.setAndRenderContentViews([view])
    this

  create: ->
    view = new App.Views.ServiceRequestsCreate()
    App.setAndRenderContentViews([view])
    this

  categoriesIndex: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get('admin') == true or App.user.get('maintenance') == true
      view = new App.Views.CategoriesIndex()
      App.setAndRenderContentViews([view])
      this
    else
      Backbone.history.navigate('home', trigger: true)
    return this

