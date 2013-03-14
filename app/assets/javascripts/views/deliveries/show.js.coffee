class App.Views.DeliveryShow extends App.Views.DeliveryCreate
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  'events': _.extend({
    'click #submit-save-delivery' : 'saveChanges'
    'click #reset-form'           : 'resetForm'
    'click #nav-prev-delivery'    : 'prevDelivery'
    'click #nav-next-delivery'    : 'nextDelivery'
    'click #edit-delivery'        : 'editDelivery',
  }, App.Views.DeliveryCreate.prototype.events)

  initialize: ->
    @items            = new App.Collections.Items
    @invoices         = new App.Collections.Invoices
    @newItems         = new App.Collections.Items
    @removeItems      = new App.Collections.Items
    @newInvoices      = new App.Collections.Invoices
    @removeInvoices   = new App.Collections.Invoices
    @formHelper       = new App.Mixins.Form
    @collectionHelper = new App.Mixins.Collections
    @listenTo App.vent, "add:item:success",    (item)            => @newItems.add(item)
    @listenTo App.vent, "add:invoice:success", (invoice)         => @newInvoices.add(invoice)
    @listenTo App.vent, "remove:item:success",  (item)           => @removeItems.add(item)
    @listenTo App.vent, "remove:invoice:success",  (invoice)     => @removeInvoices.add(invoice)

  render: ->
    $(@el).html(@template(model: @model))
    @model.invoices.each(@renderInvoice)
    @model.items.each(@renderItem)
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (e) -> $(e.target).datepicker('hide'))
    for attribute of @model.attributes
      @$('#' + attribute).val(@model.get(attribute))
    @changeCourierIcon()
    @toggleGuides()
    @calculateCosts()
    @$('#item-search-row').hide()
    @$('#search-items').show()
    @$('#invoice-search-row').hide()
    @$('#search-invoices').show()
    @$('.select2').select2({width: 'copy'})
    if @model.get('status') == "CERRADO"
      @closeDelivery()
    App.vent.trigger "render:show:delivery:success"
    this

  renderInvoice: (invoice) =>
    view = new App.Views.Invoice(model: invoice)
    App.pushToAppendedViews(view)
    @$('#invoice-form-row').after(view.render().el)
    this

  renderItem: (item) =>
    view = new App.Views.Item(model: item)
    App.pushToAppendedViews(view)
    @$('#item-form-row').after(view.render().el)
    this

  saveChanges: (e) ->
    e.preventDefault()
    invoices        = []
    items           = []
    editItems       = []
    editInvoices    = []
    removeItems     = []
    removeInvoices  = []
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
    @newInvoices.each (model) =>
      if @removeInvoices.get(model)?
        @removeInvoices.remove(model)
      else if model.isNew()
          invoice =
            invoice_number  : model.get('invoice_number')
            fob_total_cost  : model.get('fob_total_cost')
            total_units     : model.get('total_units')
            user_id         : App.user.id
          invoices.push(invoice)
      else
        editInvoices.push(model.id)
    @newItems.each (model) =>
      if @removeItems.get(model)?
        @removeItems.remove(model)
      else if model.isNew()
        item =
          code    : model.get('code')
          brand   : model.get('brand')
          season  : model.get('season')
          entry   : model.get('entry')
          user_id         : App.user.id
        items.push(item)
      else
        editItems.push(model.id)
    @removeInvoices.each (model) => removeInvoices.push(model)
    @removeItems.each    (model) => removeItems.push(model)
    attributes =
      delivery        : delivery
      invoices        : invoices
      items           : items
      editItems       : editItems
      editInvoices    : editInvoices
      removeItems     : removeItems
      removeInvoices  : removeInvoices
    @updateFormHelpers()
    @model.save attributes, success: =>
      @model.set(attributes.delivery)
      @setHeader
      @formHelper.displayFlash("success", "Los datos se han actualizado con exito", 20000)
      $('#courier').focus()
      @$('.well img')[0].src = "/assets/#{@model.get('status')}.png"
      @$('.well h1').text("Editar Envío ##{@model.id} - #{@model.get('status')}")
      @$('.well').removeClass().addClass('well ' + @model.get('status'))
      if @model.get('status') == "CERRADO"
        @closeDelivery()
    this

  resetForm: (e) ->
    e.preventDefault()
    @newItems.each (item) => @model.items.remove(item)
    @newInvoices.each (invoice) => @model.invoices.remove(invoice)
    @newItems = new App.Collections.Items
    @newInvoices = new App.Collections.Invoices
    @render()
    this

  prevDelivery: ->
    index = @collectionHelper.getModelId(@model, App.deliveries)
    collectionSize = App.deliveries.length
    if index == 0
      App.vent.trigger "deliveries:show", App.deliveries.models[(collectionSize-1)]
    else
      App.vent.trigger "deliveries:show", App.deliveries.models[(index - 1)]

  nextDelivery: ->
    index = @collectionHelper.getModelId(@model, App.deliveries)
    collectionSize = App.deliveries.length
    if index == collectionSize-1
      App.vent.trigger "deliveries:show", App.deliveries.models[0]
    else
      App.vent.trigger "deliveries:show", App.deliveries.models[(index + 1)]

  editDelivery: (e) ->
    e.preventDefault() if e?
    @$('input').attr('disabled', false)
    @$('select').attr('disabled', false)
    @$('#submit-save-delivery').show()
    @$('#edit-delivery').hide()
    @$('.clear_date').show()
    @$('.btn-mini').show()

  closeDelivery: (e) ->
    e.preventDefault() if e?
    @$('input').attr('disabled', true)
    @$('select').attr('disabled', true)
    @$('#submit-save-delivery').hide()
    @$('#edit-delivery').show()
    @$('.clear_date').hide()
    @$('table .btn-mini').hide()
