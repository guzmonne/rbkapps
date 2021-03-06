class App.Routers.PurchaseRequest extends Backbone.Router

  initialize: ->
    @listenTo App.vent, "purchase_requests:show", (model) => @setPurchaseOrder(model)

  routes:
    'purchase_request/show/:id' : 'show'
    'purchase_request/new'      : 'create'
    'purchase_request/index'    : 'index'
    'purchase_order/index'      : 'purchaseOrderIndex'

  index: ->
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

  show: (id) ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    model = new App.Models.PurchaseRequest
    model.id = id
    model.fetch success: =>
      view = new App.Views.PurchaseRequestShow(model: model)
      App.setAndRenderContentViews([view])

  old_show: (id) =>
    if App.purchaseRequests.length == 0
      App.purchaseRequests.fetch
        data:
          user_id: App.user.id
        success: =>
          model = App.purchaseRequests.get(id)
          model.lines.purchase_request_id = id
          @fetchLines(model)
    else
      model = App.purchaseRequests.get(id)
      model.lines.purchase_request_id = id
      if model.lines.length == 0
        @fetchLines(model)
      else
        view = new App.Views.PurchaseRequestShow(model: model)
        App.setAndRenderContentViews([view])
    this

  fetchLines: (model) ->
    model.lines.fetch
      success: (collection) =>
        view = new App.Views.PurchaseRequestShow(model: model)
        App.setAndRenderContentViews([view])
