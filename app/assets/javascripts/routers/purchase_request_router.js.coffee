class App.Routers.PurchaseRequest extends Backbone.Router

  routes:
    'purchase_request/show/:id': 'show'
    'purchase_request/new': 'create'

  create: ->
    purchaseRequest = new App.Models.PurchaseRequest()
    purchaseRequestView = new App.Views.PurchaseRequestCreate(model: purchaseRequest)
    App.setAndRenderContentViews([purchaseRequestView])
    this

  show: (id) ->
    console.log "PurchaseRequest Router - Show ", id
    @purchaseRequest = new App.Models.PurchaseRequest()
    @purchaseRequest.set('id', id)
    @purchaseRequest.fetch({success: @handleSuccess, error: @handleError})

  handleSuccess: (data) =>
    console.log data
    console.log @purchaseRequest
    view = new App.Views.PurchaseRequestShow(model: @purchaseRequest)
    App.setAndRenderContentViews([view])
    this

  handleError: (data, status, response) =>
    console.log data, status, response
