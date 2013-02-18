class App.Views.Invoice extends Backbone.View
  template: JST['invoices/invoice']
  tagName: 'tr'
  name: 'Invoice'

  events:
    'click #remove-invoice': 'removeInvoice'

  render: ->
    $(@el).html(@template(invoice: @model))
    this

  removeInvoice: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar esta factura?")
    if result
      @remove()
      App.vent.trigger 'removeInvoice:success', @model