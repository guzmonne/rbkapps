class App.Views.InvoiceIndex extends Backbone.View
  template: JST['invoices/index']
  className: 'span12'
  name: 'InvoiceIndex'

  events:
    'click #new-invoice'      : 'createForm'
    'click #add-new-invoice'  : 'createInvoice'
    'keydown :input'          : 'keyDownManager'
    'click #fetch-invoices'   : 'fetchInvoices'
    'click th'                : 'sortInvoices'
########################################################################################################################

################################################# $ Initialize $ #######################################################
  initialize: ->
    @flip = 0
    @fetchInvoices = _.debounce(@fetchInvoices, 300);
    @collection = App.invoices
    @headers = []
    $(window).resize => @fixHeaders() unless @collection.length == 0
    @listenTo App.vent, "minimize:invoice:success", (model) =>
      @prependInvoice(model)
    @listenTo App.vent, "remove:invoiceShow:success", (model) =>
      @prependInvoice(model)
    @listenTo App.vent, "remove:createInvoice:success", ->
      @$('#new-invoice').show()
      @$('#invoice-form-row').hide()
    @listenTo App.vent, "invoice:create:success", (model) =>
      @$('#loading-row').show()
      oldItems        = []
      newItems        = []
      model.set('user_id', App.user.id)
      model.invoice_items.each (item) ->
        if item.isNew()
          newItems.push(item.attributes)
        else
          array =
            item_id : item.id
            quantity: item.get('quantity')
          oldItems.push(array)
      object =
        id          : model.id
        invoice     : model.attributes
        old_items   : oldItems
        new_items   : newItems
      invoice = new App.Models.Invoice
      invoice.save object,
        success: (model, data) =>
          invoice = new App.Models.Invoice
          if data?
            invoice.set(data)
          else
            invoice.set(model.get('invoice'))
          @$('#new-invoice').show()
          @$('#invoice-form-row').hide()
          @prependInvoice(invoice)
          @$('#loading-row').hide()
########################################################################################################################

################################################### $ Render $ #########################################################
  render: ->
    $(@el).html(@template()).find('#invoice-form-row').hide()
    App.invoices.each(@appendInvoice)
    @$('#loading-row').hide()
    for i in [0..@$('th[data-sort]').length - 1]
      @headers.push @$(@$('th[data-sort]')[i]).data("sort")
    i = 0
    timer = setInterval( =>
      @fixHeaders()
      i++
      clearInterval(timer) if i == 10
    , 50)
    this
########################################################################################################################

############################################# $ Append Invoice $ #######################################################
  appendInvoice: (model) =>
    view = new App.Views.Invoice(model: model)
    App.pushToAppendedViews(view)
    @$('#invoices').append(view.render().el)
    @fixHeaders()
    this
########################################################################################################################

############################################# $ Append Invoice $ #######################################################
  prependInvoice: (model) =>
    view = new App.Views.Invoice(model: model)
    App.pushToAppendedViews(view)
    @$('#invoices').prepend(view.render().el)
    @fixHeaders()
    this
########################################################################################################################

############################################### $ Create Form $ ########################################################
  createForm: (e) ->
    e.preventDefault()
    model = new App.Models.Invoice
    view  = new App.Views.CreateInvoice(model: model)
    App.pushToAppendedViews(view)
    #@$('#invoice-form-row').show()
    @$('.well').after(view.render().el)
    #@$('#create-invoice').append(view.render().el)
    @$('#new-invoice').hide()
    view.hideSearchButton()
    this
########################################################################################################################

############################################## $ Create Invoice $ ######################################################
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
########################################################################################################################

########################################### $ Key Down Manager $ #######################################################
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
########################################################################################################################

############################################## $ Fetch Invoices $ ######################################################
  fetchInvoices: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:invoices:success'
    @$('#fetch-invoices').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.invoices.fetch success: =>
      @$('#fetch-invoices').html('Actualizar').removeClass('loading')
      App.invoices.each(@appendInvoice)
    this
########################################################################################################################

############################################### $ Sort Invoicew $ ######################################################
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
########################################################################################################################

################################################### $ Sort $ #########################################################
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


  fixHeaders: =>
    for header, i in @headers
      tdpadding = parseInt(@$("td[data-sort=#{header}]").css('padding'))
      tdwidth = parseInt(@$("td[data-sort=#{header}]").css('width'))
      @$("th[data-sort=#{header}]").css('padding', tdpadding)
      @$("th[data-sort=#{header}]").css('width', tdwidth)
      if (i+1) == @headers.length
        trwidth = @$("td[data-sort=#{header}]").parent().css('width')
        @$("th[data-sort=#{header}]").parent().parent().parent().css('width', trwidth)
        @$('.bodycontainer').css('height', window.innerHeight - ($('html').outerHeight() - @$('.bodycontainer').outerHeight() ) ) unless @collection.length == 0


