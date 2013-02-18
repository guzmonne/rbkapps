class App.Views.DeliveryCreate extends Backbone.View
  template: JST['deliveries/create']
  name: 'DeliveryCreate'
  className: 'span12'

  events:
    'change #courier'           : 'changeCourierIcon'
    'change #dispatch'          : 'toggleGuides'
    'click #add-new-supplier'   : 'addNewSupplier'
    'click #submit-new-supplier': 'addNewSupplier'
    'click #add-new-origin'     : 'addNewOrigin'
    'click #submit-new-origin'  : 'addNewOrigin'
    'change #brand'             : 'changeBrand'
    'change #season'            : 'changeSeason'
    'change #code'              : 'changeCode'
    'click #add-new-invoice'    : 'addNewInvoice'
    'keydown :input'            : 'keyDownManager'
    'submit #create-delivery'   : 'createDelivery'
    'click #clear-form'         : 'clearForm'

  initialize: ->
    @model = new App.Models.Delivery()
    @collection = new App.Collections.Invoices()
    @suppliers   = App.deliveries.pluckDistinct('supplier')
    @origins     = App.deliveries.pluckDistinct('origin')
    @brands      = App.items.pluckDistinct('brand')
    @formHelper = new App.Mixins.Form()
    App.vent.on('removeInvoice:success', (model) => @collection.remove(model))

  render: ->
    $(@el).html(@template(suppliers: @suppliers, origins: @origins, brands: @brands))
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

  changeBrand: (e) ->
    brand = $('#brand').val()
    if brand == "Seleccione una Marca"
      @resetSelect('#season', 'Seleccione una Temporada')
      @resetSelect('#code', 'Seleccione un Artículo')
      $('#entry').val('')
      return
    seasons = App.items.pluckDistinct('season', {brand: brand})
    $('#season option').remove()
    for season in seasons
      $('#season').append("<option>#{season}</option>")
    @changeSeason()
    this

  changeSeason: (e) ->
    season = $('#season').val()
    brand = $('#brand').val()
    $('#code option').remove()
    codes = App.items.pluckDistinct('code', {brand: brand, season: season})
    for code in codes
      $('#code').append("<option>#{code}</option>")
    @changeCode()
    this

  changeCode: (e) ->
    code    = $('#code').val()
    entry   = App.items.pluckDistinct('entry', {code: code})
    $('#entry').val(entry)
    this

  resetSelect: (id, text) ->
    $(id + " option").remove()
    $(id).append("<option>#{text}</option>")
    $(id).val(text)
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
    # @formHelper.cleanForm('#add-new-invoice-form')
    $('#invoice-form-row').after(invoiceView.render().el)
    $('#invoice_number').focus()
    @collection.add(model)
    this

  keyDownManager: (e) ->
    console.log e.keyCode, e.currentTarget
    switch e.keyCode
      when 13
        switch e.currentTarget.id
          when "invoice_number", "total_units", "fob_total_cost"
            @addNewInvoice(e)
            $('#invoice_number').focus()
            break
          when "new-supplier"
            @addNewSupplier(e)
            $('#origin').focus()
            break
          when "new-origin"
            @addNewOrigin(e)
            $('#origin_date').focus()
            break
          else
            e.preventDefault()
      when 9
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
      when 107
        switch e.currentTarget.id
          when "supplier"
            e.preventDefault()
            @addNewSupplier(e)
          when "origin"
            e.preventDefault()
            @addNewOrigin(e)
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
    @collection.each (model) =>
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
      Backbone.history.navigate "deliveries/#{@model.id}", trigger: true
    this

  clearForm: (e = null) ->
    @formHelper('#create-delivery')
    this




