class App.Views.CreateInvoice extends Backbone.View
  template: JST['invoices/create']
  name: 'AddInvoice'
  className: "row-fluid box"

  events:
    'click #save-invoice'         : 'saveInvoice'
    'click .toggle_form'          : 'toggleForm'
    'click .close'                : 'removeView'
    'focus #search-invoice'       : 'typeAheadInvoice'
    'change #search-invoice'      : 'displaySearchedInvoice'
    'click #add-searched-invoice' : 'addSearchedInvoice'

  initialize: ->
    @invoices = new App.Collections.Invoices
    @flip = 0
    @listenTo App.vent, "add:invoice_item:success", (invoice_item) =>
      @model.invoice_items.add(invoice_item)
      @$('.total_units').val((parseInt(@$('.total_units').val()) + parseInt(invoice_item.get('quantity'))))
    @listenTo App.vent, 'remove:invoice_item:success', (invoice_item) =>
      @$('.total_units').val((parseInt(@$('.total_units').val()) - parseInt(invoice_item.get('quantity'))))
    this
########################################################################################################################

################################################# $ Render $ ###########################################################
  render: ->
    $(@el).html(@template())
    @invoiceItemCreate = new App.Views.InvoiceItemCreate
    App.pushToAppendedViews(@invoiceItemCreate)
    @$('.items').html(@invoiceItemCreate.render().el)
    @$('.invoice_number').focus()
    this
########################################################################################################################

################################################## $ Save Invoice $ ####################################################
  saveInvoice: (e) ->
    e.preventDefault()
    attributes =
      invoice_number  : @$('.invoice_number').val()
      fob_total_cost  : @$('.fob_total_cost').val()
      total_units     : @$('.total_units').val()
    @model.set(attributes)
    App.vent.trigger "invoice:create:success", @model
    App.closeView(this)
########################################################################################################################

################################################## $ Remove View $ ####################################################
  removeView: (e) ->
    e.preventDefault() if e?
    result = confirm("Esta seguro que desea eliminar esta factura?")
    if result
      App.vent.trigger "remove:createInvoice:success"
      @remove()
########################################################################################################################

################################################## $ Render Show $ ####################################################
  renderShow: (e) ->
    e.preventDefault() if e?
    $(@el).html(@template())
    view = new App.Views.InvoiceItemCreate({currentItems: @model.invoice_items})
    App.pushToAppendedViews(view)
    @$('.items').html(view.render().el)
    @$('.invoice_number').val(@model.get('invoice_number'))
    @model.set('fob_total_cost', @model.get('fob_total_cost').split(' ')[1])
    @$('.fob_total_cost').val(@model.get('fob_total_cost'))
    @$('.total_units').val(@model.get('total_units'))
    @model.invoice_items.each(@renderInvoiceItem)
    this
########################################################################################################################

############################################## $ Render Invoice Item $ #################################################
  renderInvoiceItem: (item) =>
    view = new App.Views.InvoiceItem(model: item)
    App.pushToAppendedViews(view)
    @$('#items').append(view.render().el)
    this
########################################################################################################################

################################################ $ Toggle Form $ ######################################################
  toggleForm: (e) =>
    e.preventDefault() if e?
    @flip++
    @$('#add-searched-invoice').toggle()
    @$('.new_invoice').toggle()
    @$('#save-invoice').toggle()
    @$('.search_invoice').toggle()
    @$('#search-items').hide()
    @$('#search_invoice').hide()
    @$('#toggle-items-form').hide()
    @$('#item-form-row').hide()
    @$('#item-search-row').hide()
    App.vent.trigger "update:invoice_items:success"
    @invoiceItemCreate.resetItems()
    if @flip % 2 == 0
      @$('#search-invoice').val('')
      @$('#searched-fob_total_cost').text('')
      @$('#searched-total_units').text('')
      @$('.total_units').val(0)
      @$('#item-search-row').show()
      @$('#toggle-items-form').show()
########################################################################################################################

############################################# $ Type Ahead Invoice $ ###################################################
  typeAheadInvoice: () ->
    if @invoices.length == 0
      @invoices.fetch success: =>
        $('#search-invoice').removeClass('loading')
        $('#search-invoice').typeahead source: =>
          _.map(@invoices.where({delivery_id: null}), (model)  -> return model.get('invoice_number'))
    this
########################################################################################################################

############################################# $ Display Searched Item $ ################################################
  displaySearchedInvoice: (e) ->
    invoice_number = @$('#search-invoice').val()
    if invoice_number == ''
      @$('#searched-fob_total_cost').text('')
      @$('#searched-total_units').text('')
      return
    App.vent.trigger "update:invoice_items:success"
    invoice = @invoices.where(invoice_number: invoice_number, delivery_id: null)[0]
    return if invoice ==  undefined
    @$('#searched-fob_total_cost').text(invoice.get('fob_total_cost'))
    @$('#searched-total_units').text(invoice.get('total_units'))
    @model.set(invoice.attributes)
    invoice.invoice_items.fetch
      data:
        invoice_id: invoice.id
      success: (collection) =>
        collection.each (invoice_item) =>
          App.vent.trigger "add:invoice_item:success", invoice_item
          view = new App.Views.InvoiceItem(model: invoice_item)
          App.pushToAppendedViews(view)
          @$('#items').append(view.render().el).find('#remove-invoice_item').remove()
########################################################################################################################

############################################# $ Display Searched Item $ ################################################
  hideSearchButton: ->
    @$('.toggle_form').hide()
########################################################################################################################

############################################## $ Add Searched Item $ ###################################################
  addSearchedInvoice: (e) ->
    e.preventDefault() if e?
    App.vent.trigger "invoice:create:success", @model
    App.closeView(this)

