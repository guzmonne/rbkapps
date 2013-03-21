class App.Views.InvoiceShow extends Backbone.View
  template: JST['invoices/show']
  className: 'box'
  name: 'ShowInvoice'

  events:
    'click .close-invoice'        : 'removeView'
    'click .edit-invoice'         : 'editView'
########################################################################################################################

################################################### $ Initialize $ #####################################################
  initialize: ->
    @model.set('fob_total_cost', 'USD ' + parseFloat(@model.get('fob_total_cost')).toFixed(2) )
########################################################################################################################

##################################################### $ Render $ #######################################################
  render: ->
    $(@el).html(@template(model: @model))
    @model.invoice_items.each(@renderInvoiceItem)
    this
########################################################################################################################

############################################## $ Render Invoice Item $ #################################################
  renderInvoiceItem: (item) =>
    view = new App.Views.InvoiceItem(model: item)
    App.pushToAppendedViews(view)
    @$('#invoice_items').append(view.render().el).find('.btn-danger').addClass('hide')
    view.stopListening()
########################################################################################################################

################################################## $ Remove View $ #####################################################
  removeView: (e) ->
    e.preventDefault() if e?
    result = confirm("Esta seguro que desea eliminar esta factura?")
    if result
      @remove()
########################################################################################################################

################################################### $ Edit View $ ######################################################
  editView: (e) ->
    e.preventDefault() if e?
    App.vent.trigger "edit:invoice:success", @model
    @remove()
########################################################################################################################

############################################### $ Hide Edit Button $ ###################################################
  hideEditButton: ->
    @$('.edit-invoice').hide()