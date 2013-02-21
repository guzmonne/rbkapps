class App.Routers.Invoice extends Backbone.Router

  routes:
    'invoices/index'  : 'index'

  index: ->
    if App.invoices.length == 0
      App.invoices.fetch success: =>
        view = new App.Views.InvoiceIndex(collection: App.invoices)
        App.setAndRenderContentViews([view])
        this
    else
      view = new App.Views.InvoiceIndex(collection: App.invoices)
      App.setAndRenderContentViews([view])
      this

