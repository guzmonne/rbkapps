class App.Routers.Invoice extends Backbone.Router

  routes:
    'invoices/index'  : 'index'

  index: ->
    if App.user.get("comex") == true or App.user.get("admin") == true
      view = new App.Views.InvoiceIndex(collection: App.invoices)
      App.setAndRenderContentViews([view])
      this
    else
      Backbone.history.navigate('home', trigger: true)
      return this

