class App.Routers.ServiceRequests extends Backbone.Router

  routes:
    'service_requests/index'  : 'index'

  index: ->
    if App.user.get("admin") == true
      view = new App.Views.ServiceRequestsCreate()
      App.setAndRenderContentViews([view])
      this
    else
      Backbone.history.navigate('home', trigger: true)
    return this