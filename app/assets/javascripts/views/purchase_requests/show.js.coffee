class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'span12'
  name: 'ShowPurchaseRequest'

  events:
    'click #nav-prev-purchase-request': 'prevPurchaseRequest'
    'click #nav-next-purchase-request': 'nextPurchaseRequest'

  initialize: ->
    @collectionHelper = new App.Mixins.Collections

  render: ->
    $(@el).html(@template(model: @model))
    @model.lines.each(@renderLine)
    this

  renderLine: (line) =>
    view = new App.Views.PurchaseRequestLineShow(model: line)
    App.pushToAppendedViews(view)
    @$('#purchase-request-lines').append(view.render().el).find('.btn-danger').addClass('hide')

  prevPurchaseRequest: ->
    index = @collectionHelper.getModelId(@model, App.purchaseRequests)
    collectionSize = App.purchaseRequests.length
    if index == 0
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[(collectionSize-1)]
    else
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[(index - 1)]

  nextPurchaseRequest: ->
    index = @collectionHelper.getModelId(@model, App.purchaseRequests)
    collectionSize = App.purchaseRequests.length
    if index == collectionSize-1
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[0]
    else
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[(index + 1)]
