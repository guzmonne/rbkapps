class App.Routers.PurchaseRequest extends Backbone.Router

  routes:
    'purchase_request/new': 'create'

  create: ->
    purchase_request = new App.Models.PurchaseRequest()
    purchaseRequestView = new App.Views.PurchaseRequestCreate()
    App.setAndRenderContentViews([purchaseRequestView])
    this
