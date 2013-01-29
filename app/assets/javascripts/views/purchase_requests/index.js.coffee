class App.Views.PurchaseRequestIndex extends Backbone.View
  template: JST['purchase_request/index']
  className: 'span12'
  name: 'IndexPurchaseRequest'

  render: ->
    $(@el).html(@template())
    @collection.each(@appendPurchaseRequest)
    console.log @collection
    this

  appendPurchaseRequest: (model) =>
    console.log model
    model.set('updated_at', model.get('updated_at'))
    view = new App.Views.PurchaseRequest(model: model)
    App.pushToAppendedViews(view)
    @$('#purchase-requests').append(view.render().el)
    this

