class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'span12'
  name: 'ShowPurchaseRequest'

  render: ->
    $(@el).html(@template(model: @model))
    view = new App.Views.PurchaseRequestLineShow
    App.pushToAppendedViews(view)
    @collection = new App.Collections.PurchaseRequestLines()
    @collection.fetch({success: @handleSuccess})
    #find('#purchase-request-lines').html(view.render().el)
    this

    handleSuccess: ->
      console.log @collection