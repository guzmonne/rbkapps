class App.Routers.PurchaseOrder extends Backbone.Router

  routes:
    'purchase_order/index'      : 'index'

  index: ->
    view = new App.Views.PurchaseOrderIndex(collection: App.purchaseOrders)
    App.setAndRenderContentViews([view])
    this