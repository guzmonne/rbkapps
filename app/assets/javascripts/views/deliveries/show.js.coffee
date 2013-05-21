class App.Views.DeliveryShow extends App.Views.DeliveryCreate
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  'events': _.extend({
    'click #update-delivery'      : 'saveChanges'
    'click #reset-form'           : 'resetForm'
    'click #nav-prev-delivery'    : 'nextDelivery'
    'click #nav-next-delivery'    : 'prevDelivery'
    'click #edit-delivery'        : 'editDelivery'
    'click #add-note'             : 'newNote'
    'click #submit-new-note'      : 'newNote',
  }, App.Views.DeliveryCreate.prototype.events)
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @formHelper       = new App.Mixins.Form
    @collectionHelper = new App.Mixins.Collections
    @notes            = new App.Collections.Notes
    @listenTo App.vent, "change:date", (e) =>
      @$('.datepicker').datepicker('hide')
      id = @$('#origin_date')[0].id
      $("button[data-date=#{id}]").focus()
    @listenTo App.vent, "invoice:create:success", (model) =>
      view = new App.Views.InvoiceShow(model: model)
      App.pushToAppendedViews(view)
      @$('#invoices').append(view.render().el)
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
      model.destroy()
    @listenTo App.vent, "invoice:create:success", (model) =>
      @$('#loading-div').show()
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
      model.set('delivery_id', @model.id)
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
          @$('#loading-div').hide()
########################################################################################################################

############################################### $ Render $ #############################################################
  render: ->
    $(@el).html(@template(model: @model))
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (e) -> $(e.target).datepicker('hide'))
    for attribute of @model.attributes
      @$('#' + attribute).val(@model.get(attribute))
    @changeCourierIcon()
    @toggleGuides()
    @calculateCosts()
    #@$('.select2').select2({width: 'copy'})
    @model.invoices.each @renderInvoice
    @$('#loading-div').hide()
    if @model.get('status') == "CERRADO"
      @closeDelivery()
    @notes.fetch
      data:
        table_name    : 'delivery'
        table_name_id : @model.id
      success: =>
        @notes.each @renderNote
    this
########################################################################################################################

############################################ $ Render invoice $ ########################################################
  renderInvoice: (invoice) =>
    view = new App.Views.InvoiceShow(model: invoice)
    App.pushToAppendedViews(view)
    @$('#invoices').append(view.render().el)
    view.hideMinimizeButton()
    this
########################################################################################################################

############################################# $ Render Note $ ##########################################################
  renderNote: (note) =>
    view = new App.Views.NoteShow(model: note)
    App.pushToAppendedViews(view)
    @$('#notes').append(view.render().el)
    this
########################################################################################################################

############################################# $ Save Changes $ #########################################################
  saveChanges: (e) ->
    e.preventDefault()
    @formHelper.displayFlash("info", "Espere por favor...", 2000)
    $('#submit-create-delivery').attr('disabled', true)
    $('#submit-create-delivery').html('<i class="icon-load"></i>  Guardando Cambios. Espere por favor...')
    $('#courier').focus()
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
      invoice_delivery_date : $('#invoice_delivery_date').val()
      user_id           : App.user.id
    @updateFormHelpers()
    @model.save delivery,
      success: (data, status, response) =>
        @$('.alert').remove()
        @formHelper.displayFlash("success", "Los datos se han actualizado con exito", 20000)
        @$('#courier').focus()
        @$('[class^="status-"]').removeClass().addClass("status-#{@model.get('status')}")
        status = @model.get('status')
        @$('.well h1').html("Editar Envío ##{@model.id} - " + '<label class="label label-' + status + '">' + "#{status} </label>"  )
        @$('.well').removeClass().addClass('well ' + @model.get('status'))
        if @model.get('status') == "CERRADO"
          @closeDelivery()
    this
########################################################################################################################

############################################# $ Reset Form $ ###########################################################
  resetForm: (e) ->
    e.preventDefault()
    @newItems.each (item) => @model.items.remove(item)
    @newInvoices.each (invoice) => @model.invoices.remove(invoice)
    @newItems = new App.Collections.Items
    @newInvoices = new App.Collections.Invoices
    @render()
    this
########################################################################################################################

########################################## $ Previous Delivery $ #######################################################
  prevDelivery: ->
    index = @collectionHelper.getModelId(@model, App.deliveries)
    collectionSize = App.deliveries.length
    if index == 0
      App.vent.trigger "deliveries:show", App.deliveries.models[(collectionSize-1)]
    else
      App.vent.trigger "deliveries:show", App.deliveries.models[(index - 1)]
########################################################################################################################

############################################ $ Next Delivery $ #########################################################
  nextDelivery: ->
    index = @collectionHelper.getModelId(@model, App.deliveries)
    collectionSize = App.deliveries.length
    if index == collectionSize-1
      App.vent.trigger "deliveries:show", App.deliveries.models[0]
    else
      App.vent.trigger "deliveries:show", App.deliveries.models[(index + 1)]
########################################################################################################################

############################################ $ Edit Delivery $ #########################################################
  editDelivery: (e) ->
    e.preventDefault() if e?
    App.vent.trigger "invoice:show:unblock"
    @$('input').attr('disabled', false)
    @$('select').attr('disabled', false)
    @$('#update-delivery').show()
    @$('#edit-delivery').hide()
    @$('.clear_date').show()
    @$('#new_invoice').show()
########################################################################################################################

############################################ $ Close Delivery $ ########################################################
  closeDelivery: (e) ->
    e.preventDefault() if e?
    App.vent.trigger "invoice:show:block"
    @$('input').attr('disabled', true)
    @$('select').attr('disabled', true)
    @$('#update-delivery').hide()
    @$('#edit-delivery').show()
    @$('.clear_date').hide()
    @$('#new_invoice').hide()
########################################################################################################################

################################################### $ New Note $ #######################################################
  newNote: (e) ->
    e.preventDefault() if e?
    @$('#add-new-note-modal').modal('toggle')
    @$('#add-new-note-modal').on('shown', => @$('#new-note').focus() )
    newNote = @$('#new-note').val()
    if newNote == "" then return @
    @$('#new-note').val('')
    model = new App.Models.Note
    attributes =
      note:
        content       : newNote
        user_id       : App.user.id
        table_name    : 'delivery'
        table_name_id : @model.id
    model.save attributes, success: =>
      view = new App.Views.NoteShow(model: model)
      App.pushToAppendedViews(view)
      @$('#notes').append(view.render().el)
    this
