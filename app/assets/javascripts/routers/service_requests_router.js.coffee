class App.Routers.ServiceRequests extends Backbone.Router

  routes:
    'service_requests/create'  : 'index'
    'categories/index'         : 'categoriesIndex'

  index: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.get("admin") == true
      view = new App.Views.ServiceRequestsCreate()
      App.setAndRenderContentViews([view])
      this
    else
      Backbone.history.navigate('home', trigger: true)
    return this

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

