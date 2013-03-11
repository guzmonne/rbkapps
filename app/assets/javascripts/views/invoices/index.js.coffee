class App.Views.InvoiceIndex extends Backbone.View
  template: JST['invoices/index']
  className: 'span12'
  name: 'InvoiceIndex'

  initialize: ->
    @flip = 0
    @fetchInvoices = _.debounce(@fetchInvoices, 300);
    @collection = App.invoices


  events:
    'click #new-invoice'      : 'toggleForm'
    'click #add-new-invoice'  : 'createInvoice'
    'keydown :input'          : 'keyDownManager'
    'click #fetch-invoices'   : 'fetchInvoices'
    'click th'                : 'sortInvoices'

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

  fetchInvoices: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:invoices:success'
    @$('#fetch-invoices').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.invoices.fetch success: =>
      @$('#fetch-invoices').html('Actualizar').removeClass('loading')
      App.invoices.each(@appendInvoice)
    this

  sortInvoices: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar  =  @collection.sortVar
    $("th[data-sort=#{oldVar}] i").remove()
    if sortVar == oldVar
      if @collection.sortMethod == 'lTH'
        @sort(sortVar, 'hTL', 'down', type )
      else
        @sort(sortVar, 'lTH', 'up', type )
    else
      @sort(sortVar, 'lTH', 'up', type, oldVar )

  sort: (sortVar, method, direction, type, oldVar = null ) ->
    if oldVar == null then oldVar = sortVar
    if direction == 'up'
      $("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-up pull-right"></i>' )
    else
      $("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-down pull-right"></i>' )
    @collection.sortVarType= type
    @collection.sortVar    = sortVar
    @collection.sortMethod = method
    @collection.sort()
    App.vent.trigger 'update:invoices:success'
    @collection.each(@appendInvoice)

