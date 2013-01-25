class App.Views.PurchaseRequestLineCreate extends Backbone.View
  template: JST['purchase_request_line/create']
  tagName: 'table'
  className: 'table table-striped table-hover'
  name: 'CreatePurchaseRequestLine'

  render: ->
    $(@el).html(@template())
    this
