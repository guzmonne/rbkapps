class App.Views.PurchaseRequestIndex extends Backbone.View
  template: JST['purchase_request/index']
  className: 'span12'
  name: 'IndexPurchaseRequest'

  events:
    'click #new-purchase-request' : 'newPurchaseRequest'
    'click #fetch-deliveries'     : 'fetchDeliveries'

  render: ->
    $(@el).html(@template())
    @collection.each(@appendPurchaseRequest)
    this

  appendPurchaseRequest: (model) =>
    view = new App.Views.PurchaseRequest(model: model)
    App.pushToAppendedViews(view)
    @$('#purchase-requests').append(view.render().el)
    this

  newPurchaseRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_request/new', trigger: true
    this

  fetchDeliveries: (e) ->
    e.preventDefault()
    @$('#fetch-deliveries').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.purchaseRequests.fetch success: =>
      @$('#fetch-deliveries').html('Actualizar').removeClass('loading')
      App.purchaseRequests.each(@appendPurchaseRequest)
    this


