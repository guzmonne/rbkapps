class App.Views.Invoice extends Backbone.View
  template: JST['invoices/invoice']
  tagName: 'tr'
  name: 'Invoice'

  initialize: ->
    @fH = new App.Mixins.Form
    @model.set('fob_total_cost', @fH.correctDecimal(@model.get('fob_total_cost')))
    @listenTo App.vent, 'delivery:create:success', => @remove()
    # App.vent.on 'delivery:create:success', => @remove()

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