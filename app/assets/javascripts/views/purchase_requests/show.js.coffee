class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'span12'
  name: 'ShowPurchaseRequest'

  render: ->
    $(@el).html(@template(model: @model))
    view = new App.Views.PurchaseRequestLineShow()
    @collection = new App.Collections.PurchaseRequestLines()
    @collection.purchase_request_id = @model.get('id')
    @collection.fetch
      success: (collection) =>
        collection.each(@renderLine)
    this

  renderLine: (model) ->
    view = new App.Views.PurchaseRequestLineShow(model: model)
    App.pushToAppendedViews(view)
    $('#purchase-request-lines').append(view.render().el).find('.btn-danger').addClass('hide')