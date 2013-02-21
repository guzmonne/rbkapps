class App.Views.DeliveryCreate extends Backbone.View
  template: JST['deliveries/create']
  name: 'DeliveryCreate'
  className: 'span12'

  events:
    'change #courier'             : 'changeCourierIcon'
    'change #dispatch'            : 'toggleGuides'
    'click #add-new-supplier'     : 'addNewSupplier'
    'click #submit-new-supplier'  : 'addNewSupplier'
    'click #add-new-origin'       : 'addNewOrigin'
    'click #submit-new-origin'    : 'addNewOrigin'
    'click #add-new-invoice'      : 'addNewInvoice'
    'click #add-new-item'         : 'addNewItem'
    'keydown :input'              : 'keyDownManager'
    'submit #create-delivery'     : 'createDelivery'
    'click #clear-form'           : 'clearForm'
    'click #toggle-items-form'    : 'toggleItemsForm'
    'click #close-item-form'      : 'toggleItemsForm'
    'click #toggle-invoice-form'  : 'toggleInvoiceForm'
    'click #close-invoice-form'   : 'toggleInvoiceForm'
    'click #add-new-brand'        : 'addNewItemElement'
    'click #add-new-season'       : 'addNewItemElement'
    'click #add-new-entry'        : 'addNewItemElement'
    'click #search-items'         : 'searchItems'
    'click #close-searched-item'  : 'searchItems'
    'change #searched-item-code'  : 'displaySearchedItem'
    'click #add-searched-item'    : 'addSearchedItem'
    'click #search-invoices'      : 'searchInvoices'
    'click #close-searched-invoice'          : 'searchInvoices'
    'change #searched-invoice-invoice_number'  : 'displaySearchedInvoice'
    'click #add-searched-invoice'            : 'addSearchedInvoice'
    'focus #searched-invoice-invoice_number'   : 'typeaheadInvoice'

  initialize: ->
    @tabs        = 0
    @model       = new App.Models.Delivery()
    @formHelper  = new App.Mixins.Form()
    @suppliers   = App.deliveries.pluckDistinct('supplier')
    @origins     = App.deliveries.pluckDistinct('origin')
    @brands      = App.items.pluckDistinct('brand')
    @seasons     = App.items.pluckDistinct('season')
    @entries     = App.items.pluckDistinct('entry')
    @codes       = App.items.pluck('code')
    @invoices    = App.invoices.pluck('invoice_number')
    @aItems      = App.items
    @aInvoices   = App.invoices
    App.vent.on('removeInvoice:success', (model) => @model.invoices.remove(model))
    App.vent.on('removeItem:success', (model) => @model.items.remove(model))

  render: ->
    attributes = {suppliers: @suppliers, origins: @origins, brands: @brands, seasons: @seasons, entries: @entries}
    $(@el).html(@template(attributes)).find('#searched-item-code').typeahead(source: @codes)
    this

  changeCourierIcon: (e) ->
    courier = $('#courier').val()
    if courier == "Seleccione una Empresa" then return $('#courier-logo')[0].src = "/assets/rails.png"
    $('#courier-logo')[0].src = "/assets/#{courier}.png"
    this

  toggleGuides: (e) ->
    dispatch = $('#dispatch').val()
    if dispatch == "DUA"
      $('#guide2').removeClass('hide')
      $('#guide3').removeClass('hide')
      $('#cargo2').removeClass('hide')
      $('#cargo3').removeClass('hide')
      return this
    else
      if $('#guide2').hasClass('hide')
        return this
      else
        $('#guide2').addClass('hide')
        $('#guide3').addClass('hide')
        $('#cargo2').addClass('hide')
        $('#cargo3').addClass('hide')
        return this

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
    invoiceView =  new App.Views.Invoice(model: model)
    App.pushToAppendedViews(invoiceView)
    $('#invoice-form-row').after(invoiceView.render().el)
    $('#invoice_number').focus()
    @model.invoices.add(model)
    $('#invoice_number').focus()
    this

  addInvoice: (invoice) ->
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
      item_id           : App.items.where({code: $('#code').val() })[0].get('id')
    invoices = []
    @model.invoices.each (model) =>
      invoice =
        invoice_number  : model.get('invoice_number')
        fob_total_cost  : model.get('fob_total_cost')
        total_units     : model.get('total_units')
      invoices.push(invoice)
    attributes =
      delivery: delivery
      invoices: invoices
    @model.save attributes, success: =>
      App.deliveries.add(@model)
      Backbone.history.navigate "deliveries/show/#{@model.id}", trigger: true
    this

  clearForm: (e = null) ->
    @formHelper('#create-delivery')
    this

  searchItems: (e) ->
    e.preventDefault()
    $('#item-form-row').hide()
    $('#toggle-items-form').show()
    $('#item-search-row').toggle('fast').find('#searched-item-code').focus()
    $('#search-items').toggle()
    this

  searchInvoices: (e) ->
    e.preventDefault()
    $('#invoice-form-row').hide()
    $('#toggle-invoice-form').show()
    $('#invoice-search-row').toggle('fast').find('#searched-invoice-invoice_number').focus()
    $('#search-invoices').toggle()
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
    item = @aItems.where(code: code)[0]
    return if item ==  undefined
    $('#searched-item-brand').text(item.get('brand'))
    $('#searched-item-season').text(item.get('season'))
    $('#searched-item-entry').text(item.get('entry'))
    this

  addSearchedItem: (e) ->
    e.preventDefault()
    code = $('#searched-item-code').val()
    item = @aItems.where(code: code)[0]
    return if item ==  undefined
    @addItem(item)
    @codes.splice(@codes.indexOf(code), 1)
    $('#searched-item-code').typeahead(source: @codes).val('')
    @displaySearchedItem(e)

  displaySearchedInvoice: (e) ->
    invoice_number = $('#searched-invoice-invoice_number').val()
    if invoice_number == ''
      $('#searched-invoice-fob_total_cost').text('')
      $('#searched-invoice-total_units').text('')
      return
    invoice = @aInvoices.where(invoice_number: invoice_number)[0]
    return if invoice ==  undefined
    $('#searched-invoice-fob_total_cost').text('USD ' + invoice.get('fob_total_cost'))
    $('#searched-invoice-total_units').text(invoice.get('total_units'))
    this

  addSearchedInvoice: (e) ->
    e.preventDefault()
    invoice_number = $('#searched-invoice-invoice_number').val()
    invoice = @aInvoices.where(invoice_number: invoice_number)[0]
    return if invoice ==  undefined
    @addInvoice(invoice)
    @invoices.splice(@invoices.indexOf(invoice_number), 1)
    $('#searched-invoice-invoice_number').typeahead(source: @invoices).val('')
    @displaySearchedInvoice(e)

  typeaheadInvoice: (e) ->
    $('#searched-invoice-invoice_number').typeahead(source: @invoices)
    this









