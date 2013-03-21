class App.Views.Invoice extends Backbone.View
  template: JST['invoices/invoice']
  tagName: 'tr'
  name: 'Invoice'
  id: ->
    @model.cid

  initialize: ->
    @fH = new App.Mixins.Form
    @model.set('fob_total_cost', @fH.correctDecimal(@model.get('fob_total_cost')))
    @listenTo App.vent, 'delivery:create:success', => @remove()
    @listenTo App.vent, 'remove:invoices', => @remove()
    @listenTo App.vent, 'update:invoices:success', => @remove()

  events:
    'click #remove-invoice': 'removeInvoice'

  render: ->
    $(@el).html(@template(invoice: @model))
    this

  removeInvoice: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar esta factura?")
    if result
      App.vent.trigger 'remove:invoice:success', @model
      @remove()
