class App.Views.DeliveryCreate extends Backbone.View
  template: JST['deliveries/create']
  itemTable: JST['deliveries/new_item_table']
  name: 'DeliveryCreate'
  className: 'span12'

  events:
    'change #courier'                          : 'changeCourierIcon'
    'change #dispatch'                         : 'toggleGuides'
    'click #add-new-supplier'                  : 'addNewSupplier'
    'click #submit-new-supplier'               : 'addNewSupplier'
    'click #add-new-origin'                    : 'addNewOrigin'
    'click #submit-new-origin'                 : 'addNewOrigin'
    'keydown :input'                           : 'keyDownManager'
    'submit #create-delivery'                  : 'createDelivery'
    'click .clear_date'                        : 'clearDate'
    'focus .clear_date'                        : 'hideDatePicker'
    'change .cost'                             : 'calculateCosts'
    'click #new_invoice'                       : 'newInvoice'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @tabs        = 0
    @model       = new App.Models.Delivery()
    @formHelper  = new App.Mixins.Form()
    @listenTo App.vent, "change:date", (e) =>
      @$('.datepicker').datepicker('hide')
      id = @$('#origin_date')[0].id
      $("button[data-date=#{id}]").focus()
    @listenTo App.vent, "invoice:create:success", (model) =>
      view = new App.Views.InvoiceShow(model: model)
      App.pushToAppendedViews(view)
      @$('#invoices').append(view.render().el)
      view.hideEditButton() unless model.isNew()
      view.hideMinimizeButton()
      @$('#new_invoice').show()
      @model.invoices.add(model)
      @calculateCosts()
    @listenTo App.vent, "edit:invoice:success", (model) =>
      view = new App.Views.CreateInvoice(model: model)
      App.pushToAppendedViews(view)
      @$('#invoices').prepend(view.renderShow().el)
      view.hideMinimizeButton()
      @model.invoices.remove(model)
      @$('#new_invoice').hide()
      @calculateCosts()
    @listenTo App.vent, "remove:createInvoice:success", =>
      @$('#new_invoice').show()
    @listenTo App.vent, "remove:invoiceShow:success", (model) =>
      @model.invoices.remove(model)
########################################################################################################################

################################################# $ Render $ ###########################################################
  render: ->
    $(@el).html(@template()).find('.select2').select2({width: 'copy'})
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', -> App.vent.trigger 'change:date', this)
    this
########################################################################################################################

########################################## $ Change Courier Icon $ #####################################################
  changeCourierIcon: (e) ->
    courier = @$('#courier').val()
    #if courier == "Seleccione una Empresa" then return $('#courier-logo')[0].src = "/assets/rails.png"
    #@$('#courier-logo')[0].src = "/assets/#{courier}.png"
    if courier == "Seleccione una Empresa"
      return @$('[class^="courier-"]').removeClass().addClass("courier-empty")
    @$('[class^="courier-"]').removeClass().addClass("courier-#{courier}")
    this
########################################################################################################################

############################################# $ Toggle Guides $ ########################################################
  toggleGuides: (e) ->
    @$('.dispatch').hide()
    dispatch = @$('#dispatch').val()
    @$('.' + dispatch).fadeIn('fast')
    this
########################################################################################################################

############################################ $ Add New Supplier $ ######################################################
  addNewSupplier: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-supplier-modal", "#new-supplier", "#supplier")
    this
########################################################################################################################

############################################# $ Add New Origin $ #######################################################
  addNewOrigin: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-origin-modal", "#new-origin", "#origin")
    this
########################################################################################################################

############################################# $ Key Down Manager $ #####################################################
  keyDownManager: (e) ->
    switch e.keyCode
      when 13 # Enter
        switch e.currentTarget.id
          when "new-supplier"
            @addNewSupplier(e)
            $('#origin').focus()
            break
          when "new-origin"
            @addNewOrigin(e)
            $('#origin_date').focus()
            break
          when "cargo_cost"
            e.preventDefault()
            switch $('#dispatch').val()
              when "MONO"
                $('#dispatch_cost').focus()
                break
              when "DUA"
                $('#cargo_cost2').focus()
                break
              when "LIBERADO"
                $('#supplier').focus()
                break
            break
          when "cargo_cost2"
            e.preventDefault()
            $('#cargo_cost3').focus()
            break
          when "cargo_cost3"
            e.preventDefault()
            $('#dispatch_cost').focus()
            break
          when "dispatch_cost"
            e.preventDefault()
            $('#dua_cost').focus()
            break
          when "guide"
            if $('#dispatch').val() == "LIBERADO" or $('#dispatch').val() == "MONO"
              e.preventDefault()
              $('#cargo_cost').focus()
            else
              e.preventDefault()
              $('#guide2').focus()
            break
          when "guide2"
            e.preventDefault()
            $('#guide3').focus()
            break
          when "guide3"
            e.preventDefault()
            $('#cargo_cost').focus()
            break
          when "dua_cost"
            e.preventDefault()
            $('#supplier').select2("open")
            break
          when "exchange_rate"
            e.preventDefault()
            $('#cargo_cost').focus()
            break
          when "new-note"
            e.preventDefault()
            @newNote()
          else
            e.preventDefault()
      when 9 # Tab
        switch e.currentTarget.id
          when "supplier"
            e.preventDefault()
            $('#origin').focus()
            break
          when "origin"
            e.preventDefault()
            $('#origin_date').focus()
            break
          when "total_units"
            e.preventDefault()
            $('#invoice_number').focus()
            break
          when "doc_courier_date"
            @tabs++
            break unless @tabs % 3 == 0
            e.preventDefault()
            $('#searched-item-code').focus()
            break
          when "searched-item-code"
            e.preventDefault()
            $('#searched-invoice-invoice_number').focus()
            break
          when "searched-invoice-invoice_number"
            e.preventDefault()
            $('#searched-invoice-invoice_number').focus()
            break
          when "last_trash"
            e.preventDefault()
            $('#searched-item-code').focus()
            break
          when "cargo_cost"
            e.preventDefault()
            switch $('#dispatch').val()
              when "MONO"
                $('#dispatch_cost').focus()
                break
              when "DUA"
                $('#cargo_cost2').focus()
                break
              when "LIBERADO"
                $('#supplier').focus()
                break
            break
          when "cargo_cost2"
            e.preventDefault()
            $('#cargo_cost3').focus()
            break
          when "cargo_cost3"
            e.preventDefault()
            $('#dispatch_cost').focus()
            break
          when "dispatch_cost"
            e.preventDefault()
            $('#dua_cost').focus()
            break
          when "guide"
            if $('#dispatch').val() == "LIBERADO" or $('#dispatch').val() == "MONO"
              e.preventDefault()
              $('#cargo_cost').focus()
            else
              e.preventDefault()
              $('#guide2').focus()
            break
          when "guide3"
            e.preventDefault()
            $('#cargo_cost').focus()
            break
          when "dua_cost"
            e.preventDefault()
            $('#supplier').select2("open")
            break
          when "exchange_rate"
            e.preventDefault()
            $('#cargo_cost').focus()
            break
      when 107 # Plus
        switch e.currentTarget.id
          when "supplier"
            e.preventDefault()
            @addNewSupplier(e)
          when "origin"
            e.preventDefault()
            @addNewOrigin(e)
    this
########################################################################################################################

############################################## $ Create Delivery $ #####################################################
  createDelivery: (e) ->
    e.preventDefault()
    @formHelper.displayFlash("info", "Espere por favor...", 2000)
    $('#submit-create-delivery').attr('disabled', true)
    $('#submit-create-delivery').html('<i class="icon-load"></i>  Espere por favor...')
    $('#courier').focus()
    newInvoices    = []
    oldInvoices    = []
    delivery =
      courier           : $('#courier').val()
      dispatch          : $('#dispatch').val()
      guide             : $('#guide').val()
      guide2            : $('#guide2').val()
      guide3            : $('#guide3').val()
      cargo_cost        : $('#cargo_cost').val()
      cargo_cost2       : $('#cargo_cost2').val()
      cargo_cost3       : $('#cargo_cost3').val()
      dispatch_cost     : $('#dispatch_cost').val()
      dua_cost          : $('#dua_cost').val()
      supplier          : $('#supplier').val()
      origin            : $('#origin').val()
      origin_date       : $('#origin_date').val()
      arrival_date      : $('#arrival_date').val()
      delivery_date     : $('#delivery_date').val()
      status            : $('#status').val()
      doc_courier_date  : $('#doc_courier_date').val()
      exchange_rate     : $('#exchange_rate').val()
      user_id           : App.user.id
    @model.invoices.each (invoice) =>
        if invoice.isNew()
          oldItems     = []
          newItems     = []
          invoice.invoice_items.each (item) ->
            if item.isNew()
              newItems.push(item.attributes)
            else
              array =
                id      : item.id
                quantity: item.get('quantity')
              oldItems.push(array)
          object =
            invoice     : invoice.attributes
            old_items   : oldItems
            new_items   : newItems
          newInvoices.push(object)
        else
          oldInvoices.push( id: invoice.id)
    attributes =
      delivery      : delivery
      invoices      : oldInvoices
      new_invoices  : newInvoices

    @updateFormHelpers()
    @model.save attributes, success: =>
      App.vent.trigger "delivery:create:success"
      App.deliveries.add(@model)
      @render()
      @formHelper.displayFlash("success", "El envío se ha creado con exito", 20000)
      @model          = new App.Models.Delivery
      @model.invoices = new App.Collections.Invoices
      App.closeAppendedViews()
    this
########################################################################################################################

########################################### $ Update Form Helpers $ ####################################################
  updateFormHelpers: () ->
    attributes = [
      {supplier: @setOrNull('supplier', 'Seleccione un Proveedor')}
      {origin  : @setOrNull('origin', 'Lugar de Origen')}
    ]
    App.formHelpers.addHelpers(attributes)
    this
########################################################################################################################

################################################## $ Set or Null $ #####################################################
  setOrNull: (id, value) ->
    if $('#' + id).val()  == value then result = null else result = $('#' + id).val()
    return result
########################################################################################################################

############################################### $ Date Functions $ #####################################################
  clearDate: (e) ->
    e.preventDefault()
    @$('#' + e.currentTarget.dataset.date).val('')
  hideDatePicker: =>
    @$('.datepicker').datepicker('hide')
########################################################################################################################

################################################## $ Set or Zero $ #####################################################
  setOrZero: (id) ->
    if @$('#' + id).val() == ''
      result = 0
    else
      result = parseFloat @$('#' + id).val()
      @$('#' + id).val result.toFixed(2)
    return result
########################################################################################################################

################################################ $ Calculate Costs $ ###################################################
  calculateCosts: ->
    cargo_cost        = @setOrZero('cargo_cost')
    cargo_cost2       = @setOrZero('cargo_cost2')
    cargo_cost3       = @setOrZero('cargo_cost3')
    dispatch_cost     = @setOrZero('dispatch_cost')
    dua_cost          = @setOrZero('dua_cost')
    er                = @setOrZero('exchange_rate')
    total_cargo_cost  = cargo_cost + cargo_cost2 + cargo_cost3 + dispatch_cost + dua_cost
    if er == 0
      total_cargo_cost_dollars = 0
    else
      total_cargo_cost_dollars = total_cargo_cost / er
    total_fob_cost             = 0
    fob_total_costs            = @model.invoices.pluck('fob_total_cost')
    if fob_total_costs.length > 0
      for fob_total_cost in fob_total_costs
        total_fob_cost = total_fob_cost + parseFloat(fob_total_cost)
    total = total_cargo_cost_dollars + total_fob_cost
    @$('#total_cargo_cost').val         total_cargo_cost.toFixed(2)
    @$('#total_cargo_cost_dollars').val total_cargo_cost_dollars.toFixed(2)
    @$('#fob_cost_total').val           total_fob_cost.toFixed(2)
    @$('#cost_total').val               total.toFixed(2)
########################################################################################################################

################################################### $ New Invoice $ ####################################################
  newInvoice: (e) ->
    e.preventDefault() if e?
    model   = new App.Models.Invoice
    view    = new App.Views.CreateInvoice(model: model, currentInvoices: @model.invoices)
    App.pushToAppendedViews(view)
    @$('#invoices').prepend(view.render().el)
    view.hideMinimizeButton()
    @$('#new_invoice').hide()
