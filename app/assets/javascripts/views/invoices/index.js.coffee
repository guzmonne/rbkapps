class App.Views.InvoiceIndex extends Backbone.View
  template: JST['invoices/index']
  className: 'span12'
  name: 'InvoiceIndex'

  initialize: ->
    @flip = 0

  events:
    'click #new-invoice'      : 'toggleForm'
    'click #add-new-invoice'  : 'createInvoice'
    'keydown :input'          : 'keyDownManager'
    'click #fetch-deliveries' : 'fetchDeliveries'

  render: ->
    $(@el).html(@template()).find('#invoice-form-row').hide()
    App.invoices.each(@appendInvoice)
    this

  appendInvoice: (model) =>
    view = new App.Views.Invoice(model: model)
    App.pushToAppendedViews(view)
    @$('#invoices').append(view.render().el)
    this

  toggleForm: (e) ->
    e.preventDefault()
    $('#invoice-form-row').toggle(@flip++ % 2 == 0)
    unless @flip % 2 == 0
      $('#invoice_number').focus()
      return $('#new-invoice').text('Cerrar Formulario')
    $('#new-invoice').html('<i class="icon-plus icon-white"></i>Nueva Factura')
    this

  createInvoice: (e) ->
    e.preventDefault()
    model = new App.Models.Invoice()
    attributes =
      invoice_number: $('#invoice_number').val()
      fob_total_cost: $('#fob_total_cost').val()
      total_units   : $('#total_units').val()
      user_id       : App.user.get('id')
    model.save(attributes)
    $('#invoice_number').val('')
    $('#fob_total_cost').val('')
    $('#total_units').val('1')
    invoiceView =  new App.Views.Invoice(model: model)
    App.pushToAppendedViews(invoiceView)
    $('#invoice-form-row').after(invoiceView.render().el)
    $('#invoice_number').focus()
    App.invoices.add(model)
    this

  keyDownManager: (e) ->
    switch e.keyCode
      when 13
        switch e.currentTarget.id
          when "invoice_number", "total_units", "fob_total_cost"
            @createInvoice(e)
            $('#invoice_number').focus()
            break
          else
            e.preventDefault()
      when 9
        switch e.currentTarget.id
          when "total_units"
            e.preventDefault()
            $('#invoice_number').focus()
            break
    this

  fetchDeliveries: (e) ->
    e.preventDefault()
    @$('#fetch-deliveries').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.invoices.fetch success: =>
      @$('#fetch-deliveries').html('Actualizar').removeClass('loading')
      App.invoices.each(@appendInvoice)
    this

