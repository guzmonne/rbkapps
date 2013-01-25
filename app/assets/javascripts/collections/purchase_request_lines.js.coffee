class App.Collections.PurchaseRequestLines extends Backbone.Collection
  model: App.Models.PurchaseOrderLine
  url: 'api/purchase_requests'