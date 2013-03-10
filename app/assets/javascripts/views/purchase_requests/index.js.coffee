class App.Views.PurchaseRequestIndex extends Backbone.View
  template: JST['purchase_request/index']
  className: 'span12'
  name: 'IndexPurchaseRequest'

  events:
    'click #new-purchase-request'        : 'newPurchaseRequest'
    'click #fetch-purchase_requests'     : 'fetchPurchaseRequests'

  initialize: ->
    @fetchPurchaseRequests = _.debounce(@fetchPurchaseRequests, 300);

  render: ->
    $(@el).html(@template())
    @collection.each(@appendPurchaseRequest)
    unless App.items.length == 0 then @$('.table').tablesorter()
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

  fetchPurchaseRequests: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:purchase_requests'
    @$('#fetch-purchase_requests').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.purchaseRequests.fetch data: {user_id: App.user.id}, success: =>
      @$('#fetch-purchase_requests').html('Actualizar').removeClass('loading')
      App.purchaseRequests.each(@appendPurchaseRequest)
      @$('.table').tablesorter()
    this


