class App.Routers.PurchaseRequest extends Backbone.Router

  initialize: ->
    App.vent.on "purchase_requests:show", @setPurchaseOrder, this

  routes:
    'purchase_request/show/:id': 'show'
    'purchase_request/new': 'create'
    'purchase_request/index': 'index'

  index: ->
    if App.purchaseRequests.length < 2
      App.purchaseRequests.fetch
        success: =>
          view = new App.Views.PurchaseRequestIndex(collection: App.purchaseRequests)
          App.setAndRenderContentViews([view])
    else
      view = new App.Views.PurchaseRequestIndex(collection: App.purchaseRequests)
      App.setAndRenderContentViews([view])
    this

  setPurchaseOrder: (model) ->
    Backbone.history.navigate "purchase_request/show/#{model.get('id')}", true

  create: ->
    purchaseRequest = new App.Models.PurchaseRequest()
    purchaseRequestView = new App.Views.PurchaseRequestCreate(model: purchaseRequest)
    App.setAndRenderContentViews([purchaseRequestView])
    this

  show: (id) =>
    if App.purchaseRequests.length == 0
      App.purchaseRequests.fetch
        success: =>
          model = App.purchaseRequests.get(id)
          model.lines.purchase_request_id = model.id
          model.lines.fetch
            success: (collection) =>
              view = new App.Views.PurchaseRequestShow(model: model)
              App.setAndRenderContentViews([view])
    else
      model = App.purchaseRequests.get(id)
      model.lines.purchase_request_id = model.id
      if model.lines.length == 0
        model.lines.fetch
          success: (collection) =>
            view = new App.Views.PurchaseRequestShow(model: model)
            App.setAndRenderContentViews([view])
      else
        view = new App.Views.PurchaseRequestShow(model: model)
        App.setAndRenderContentViews([view])
    this

  # show: ->
  #   @purchaseRequest = new App.Models.PurchaseRequest()
  #   @purchaseRequest.set('id', id)
  #   @purchaseRequest.fetch({success: @handleSuccess, error: @handleError})

  # handleSuccess: (data) =>
  #  view = new App.Views.PurchaseRequestShow(model: @purchaseRequest)
  #  App.setAndRenderContentViews([view])
  #  this

  handleError: (data, status, response) =>
    console.log data, status, response
