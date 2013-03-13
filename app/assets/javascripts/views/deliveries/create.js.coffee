class App.Views.DeliveryCreate extends Backbone.View
  template: JST['deliveries/create']
  name: 'DeliveryCreate'
  className: 'span12'

  events:
    'change #courier'                          : 'changeCourierIcon'
    'change #dispatch'                         : 'toggleGuides'
    'click #add-new-supplier'                  : 'addNewSupplier'
    'click #submit-new-supplier'               : 'addNewSupplier'
    'click #add-new-origin'                    : 'addNewOrigin'
    'click #submit-new-origin'                 : 'addNewOrigin'
    'click #add-new-invoice'                   : 'addNewInvoice'
    'click #add-new-item'                      : 'addNewItem'
    'keydown :input'                           : 'keyDownManager'
    'submit #create-delivery'                  : 'createDelivery'
    'click #toggle-items-form'                 : 'toggleItemsForm'
    'click #close-item-form'                   : 'toggleItemsForm'
    'click #toggle-invoice-form'               : 'toggleInvoiceForm'
    'click #close-invoice-form'                : 'toggleInvoiceForm'
    'click #add-new-brand'                     : 'addNewItemElement'
    'click #add-new-season'                    : 'addNewItemElement'
    'click #add-new-entry'                     : 'addNewItemElement'
    'click #search-items'                      : 'searchItems'
    'click #close-searched-item'               : 'searchItems'
    'change #searched-item-code'               : 'displaySearchedItem'
    'click #add-searched-item'                 : 'addSearchedItem'
    'click #search-invoices'                   : 'searchInvoices'
    'click #close-searched-invoice'            : 'searchInvoices'
    'change #searched-invoice-invoice_number'  : 'displaySearchedInvoice'
    'click #add-searched-invoice'              : 'addSearchedInvoice'
    'focus #searched-item-code'                : 'typeAheadItem'
    'focus #searched-invoice-invoice_number'   : 'typeAheadInvoice'
    'click .clear_date'                        : 'clearDate'
    'focus .clear_date'                        : 'hideDatePicker'

  initialize: ->
    @tabs        = 0
    @invoices    = new App.Collections.Invoices
    @items       = new App.Collections.Items
    @model       = new App.Models.Delivery()
    @formHelper  = new App.Mixins.Form()
    @listenTo App.vent, 'remove:invoice:success', (model) =>
      @model.invoices.remove(model)
      @invoices.add(model)
      $('#searched-invoice-invoice_number').typeahead source: =>
        _.map(@invoices.where({delivery_id: null}), (model)  -> return model.get('invoice_number'))
    @listenTo App.vent, 'remove:item:success', (model) =>
      @model.items.remove(model)
      @items.add(model)
      $('#searched-item-code').data('typeahead').source = @items.pluck('code')
    @listenTo App.vent, "change:date", (e) =>
      @$('.datepicker').datepicker('hide')
      id = @$('#origin_date')[0].id
      $("button[data-date=#{id}]").focus()

  render: ->
    $(@el).html(@template()).find('.select2').select2({width: 'copy'})
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', -> App.vent.trigger 'change:date', this)
    this

  changeCourierIcon: (e) ->
    courier = @$('#courier').val()
    if courier == "Seleccione una Empresa" then return $('#courier-logo')[0].src = "/assets/rails.png"
    @$('#courier-logo')[0].src = "/assets/#{courier}.png"
    this

  toggleGuides: (e) ->
    @$('.dispatch').hide()
    dispatch = @$('#dispatch').val()
    @$('.' + dispatch).fadeIn('fast')
    this

  addNewSupplier: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-supplier-modal", "#new-supplier", "#supplier")
    this

  addNewOrigin: (e) ->
    e.preventDefault()
    @formHelper.modalToSelect("#add-new-origin-modal", "#new-origin", "#origin")
    this

  addNewInvoice: (e) ->
    e.preventDefault()
    model = new App.Models.Invoice()
    attributes =
      invoice_number: $('#invoice_number').val()
      fob_total_cost: $('#fob_total_cost').val()
      total_units   : $('#total_units').val()
    model.set(attributes)
    $('#invoice_number').val('')
    $('#fob_total_cost').val('')
    $('#total_units').val('1')
    App.vent.trigger "add:invoice:success", model
    invoiceView =  new App.Views.Invoice(model: model)
    App.pushToAppendedViews(invoiceView)
    $('#invoice-form-row').after(invoiceView.render().el)
    $('#invoice_number').focus()
    @model.invoices.add(model)
    $('#invoice_number').focus()
    this

  addInvoice: (invoice) ->
    App.vent.trigger "add:invoice:success", invoice
    invoiceView =  new App.Views.Invoice(model: invoice)
    App.pushToAppendedViews(invoiceView)
    $('#invoice-form-row').after(invoiceView.render().el)
    @model.invoices.add(invoice)
    this

  addNewItem: (e) ->
    e.preventDefault()
    model = new App.Models.Item()
    attributes =
      code  : $('#code').val()
      brand : $('#brand').val()
      season: $('#season').val()
      entry : $('#entry').val()
    model.set(attributes)
    $('#code').val('')
    $('#brand').val('')
    $('#season').val('')
    $('#entry').val('')
    @addItem(model)
    $('#code').focus()
    this

  addItem: (item, afterElement = null) ->
    App.vent.trigger "add:item:success", item
    itemView =  new App.Views.Item(model: item)
    App.pushToAppendedViews(itemView)
    if afterElement == null
      $('#item-form-row').after(itemView.render().el)
    else
      $(afterElement).after(itemView.render().el)
    @model.items.add(item)

  keyDownManager: (e) ->
    switch e.keyCode
      when 13 # Enter
        switch e.currentTarget.id
          when "invoice_number", "total_units", "fob_total_cost"
            @addNewInvoice(e)
            $('#invoice_number').focus()
            break
          when "code", "brand", "season", "entry"
            @addNewItem(e)
            $('#code').focus()
            break
          when "new-brand", "new-season", "new-entry"
            @addNewItemElement(e)
            $(e.currentTarget.id).focus()
            break
          when "new-supplier"
            @addNewSupplier(e)
            $('#origin').focus()
            break
          when "new-origin"
            @addNewOrigin(e)
            $('#origin_date').focus()
            break
          when "searched-item-code"
            @addSearchedItem(e)
            break
          when "searched-invoice-invoice_number"
            @addSearchedInvoice(e)
            break
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
          when "entry"
            e.preventDefault()
            $('#code').focus()
            break
          when "brand"
            e.preventDefault()
            $('#season').focus()
            break
          when "season"
            e.preventDefault()
            $('#entry').focus()
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
      when 107 # Plus
        switch e.currentTarget.id
          when "supplier"
            e.preventDefault()
            @addNewSupplier(e)
          when "origin"
            e.preventDefault()
            @addNewOrigin(e)
          when "brand", "season", "entry"
            @addNewItemElement(e)
            $(e.currentTarget.id).focus()
            break
          when "new-brand", "new-season", "new-entry"
            @addNewItemElement(e)
            $(e.currentTarget.id).focus()
            break
    this

  createDelivery: (e) ->
    e.preventDefault()
    @formHelper.displayFlash("info", "Espere por favor...", 2000)
    $('#submit-create-delivery').attr('disabled', true)
    $('#submit-create-delivery').html('<i class="icon-load"></i>  Espere por favor...')
    $('#courier').focus()
    invoices      = []
    items         = []
    editItems     = []
    editInvoices  = []
    # if message == @validate
    #  @formHelper.displayFlash('alert', message, 20000)
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
      user_id           : App.user.id
    @model.invoices.each (model) =>
      if model.isNew()
        invoice =
          invoice_number  : model.get('invoice_number')
          fob_total_cost  : model.get('fob_total_cost')
          total_units     : model.get('total_units')
          user_id         : App.user.id
        invoices.push(invoice)
      else
        editInvoices.push(model.id)
    @model.items.each (model) =>
      if model.isNew()
        item =
          code    : model.get('code')
          brand   : model.get('brand')
          season  : model.get('season')
          entry   : model.get('entry')
          user_id         : App.user.id
        items.push(item)
      else
        editItems.push(model.id)
    attributes =
      delivery    : delivery
      invoices    : invoices
      items       : items
      editItems   : editItems
      editInvoices: editInvoices
    @updateFormHelpers()
    @model.save attributes, success: =>
      App.vent.trigger "delivery:create:success"
      App.deliveries.add(@model)
      @render()
      @formHelper.displayFlash("success", "El envío se ha creado con exito", 20000)
      @model          = new App.Models.Delivery
      @model.items    = new App.Collections.Items
      @model.invoices = new App.Collections.Invoices
      @items          = new App.Collections.Items
      @invoices       = new App.Collections.Invoices
      App.closeAppendedViews()
    this

  searchItems: (e) ->
    e.preventDefault() if e?
    @$('#item-form-row').hide()
    @$('#toggle-items-form').show()
    @$('#item-search-row').toggle('fast').find('#searched-item-code').focus()
    @$('#search-items').toggle()
    this

  searchInvoices: (e) ->
    e.preventDefault() if e?
    @$('#invoice-form-row').hide()
    @$('#toggle-invoice-form').show()
    @$('#invoice-search-row').toggle('fast').find('#searched-invoice-invoice_number').focus()
    @$('#search-invoices').toggle()
    this

  toggleItemsForm: (e) ->
    e.preventDefault()
    $('#item-search-row').hide()
    $('#search-items').show()
    $('#item-form-row').toggle('fast').find('#code').focus()
    $('#toggle-items-form').toggle()
    this

  toggleInvoiceForm: (e) ->
    e.preventDefault()
    $('#invoice-search-row').hide()
    $('#search-invoices').show()
    $('#invoice-form-row').toggle('fast').find('#invoice_number').focus()
    $('#toggle-invoice-form').toggle()
    this

  addNewItemElement: (e) ->
    e.preventDefault()
    l = e.currentTarget.id.split('-').length
    element = e.currentTarget.id.split('-')[l-1]
    if $("#new-" + element).hasClass('hide')
      $("#" + element).toggle('fast')
      $("#new-" + element).removeClass('hide').hide().toggle('fast')
      $("#add-new-" + element).html('<i class="icon-ok icon-white"></i>')
      $("#new-" + element).focus()
    else
      text = $("#new-" + element).val()
      if text == ''
        $("#" + element).toggle('fast').focus()
      else
        $("#" + element).toggle('fast').focus().append("<option>#{text}</option>").val(text)
      $("#add-new-" + element).html('<i class="icon-plus icon-white"></i>')
      $("#new-" + element).toggle('fast').addClass('hide').val('')
    this

  displaySearchedItem: (e) ->
    code = $('#searched-item-code').val()
    if code == ''
      $('#searched-item-brand').text('')
      $('#searched-item-season').text('')
      $('#searched-item-entry').text('')
      return
    item = @items.where(code: code)[0]
    return if item ==  undefined
    $('#searched-item-brand').text(item.get('brand'))
    $('#searched-item-season').text(item.get('season'))
    $('#searched-item-entry').text(item.get('entry'))
    this

  addSearchedItem: (e) ->
    e.preventDefault()
    code = $('#searched-item-code').val()
    item = @items.where(code: code)[0]
    return if item ==  undefined
    @addItem(item)
    @items.remove(item)
    items = @items.pluck('code')
    $('#searched-item-code').val('')
    $('#searched-item-code').typeahead(source: items)
    @displaySearchedItem(e)

  displaySearchedInvoice: (e) ->
    invoice_number = $('#searched-invoice-invoice_number').val()
    if invoice_number == ''
      $('#searched-invoice-fob_total_cost').text('')
      $('#searched-invoice-total_units').text('')
      return
    invoice = @invoices.where(invoice_number: invoice_number)[0]
    return if invoice ==  undefined
    $('#searched-invoice-fob_total_cost').text('USD ' + invoice.get('fob_total_cost'))
    $('#searched-invoice-total_units').text(invoice.get('total_units'))
    this

  addSearchedInvoice: (e) ->
    e.preventDefault()
    invoice_number = $('#searched-invoice-invoice_number').val()
    invoice = @invoices.where(invoice_number: invoice_number)[0]
    return if invoice ==  undefined
    @addInvoice(invoice)
    @invoices.remove(invoice)
    $('#searched-invoice-invoice_number').val('')
    @typeAheadInvoice
    @displaySearchedInvoice(e)

  typeAheadInvoice: () ->
    if @invoices.length == 0
      @invoices.fetch success: =>
        $('#searched-invoice-invoice_number').removeClass('loading')
        $('#searched-invoice-invoice_number').typeahead source: =>
          _.map(@invoices.where({delivery_id: null}), (model)  -> return model.get('invoice_number'))
    this

  typeAheadItem: () ->
    if @items.length == 0
      @items.fetch success: =>
        $('#searched-item-code').removeClass('loading')
        $('#searched-item-code').typeahead source: =>
          @items.pluck("code")
    this

  updateFormHelpers: () ->
    attributes = [
      {supplier: @setOrNull('supplier', 'Seleccione un Proveedor')}
      {origin  : @setOrNull('origin', 'Lugar de Origen')}
      {brand   : @setOrNull('brand', 'Seleccione una Marca') }
      {season  : @setOrNull('season', 'Seleccione una Temporada')}
      {entry   : @setOrNull('entry', 'Seleccione un Rubro')}
    ]
    App.formHelpers.addHelpers(attributes)
    this

  setOrNull: (id, value) ->
    if $('#' + id).val()  == value then result = null else result = $('#' + id).val()
    return result

  clearDate: (e) ->
    e.preventDefault()
    @$('#' + e.currentTarget.dataset.date).val('')

  hideDatePicker: =>
    @$('.datepicker').datepicker('hide')




