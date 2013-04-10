class App.Routers.Supplier extends Backbone.Router

  routes:
    'suppliers/index'        : 'index'

  index: ->
    view = new App.Views.SupplierIndex
    App.setAndRenderContentViews([view])
    this
