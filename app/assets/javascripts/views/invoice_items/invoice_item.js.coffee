class App.Views.InvoiceItem extends Backbone.View
  template: JST['invoice_items/invoice_item']
  tagName: 'tr'
  name: 'InvoiceItem'

  initialize: ->
    @listenTo App.vent, 'delivery:create:success', => @remove()
    @listenTo App.vent, 'update:invoice_items:success', => @remove()

  events:
    'click #remove-invoice_item': 'removeInvoiceItem'

  render: ->
    $(@el).html(@template(model: @model))
    this

  removeInvoiceItem: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar este artículo")
    if result
      App.vent.trigger 'remove:invoice_item:success', @model
      @remove()