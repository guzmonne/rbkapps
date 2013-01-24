class App.Collections.PurchaseRequests extends Backbone.Collection
  model: App.Models.PurchaseOrder
  url: 'api/purchase_requests'