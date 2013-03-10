class App.Collections.PurchaseRequests extends Backbone.Collection
  model: App.Models.PurchaseRequest
  url: '/api/purchase_requests'
  user_id: null
