class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'row-fluid'
  name: 'ShowPurchaseRequest'
########################################################################################################################

################################################ $ Events $ ############################################################
  events:
    'click #nav-prev-purchase-request': 'nextPurchaseRequest'
    'click #nav-next-purchase-request': 'prevPurchaseRequest'
    'click #approve-purchase-request' : 'approveRequest'
    'click #reject-purchase-request'  : 'rejectRequest'
    'click #edit-cost_center'         : 'toggleCostCenter'
    'click #cancel-change-cost_center': 'toggleCostCenter'
    'click #change-cost_center'       : 'changeCostCenter'
    'click #edit-state'               : 'toggleState'
    'click #cancel-change-state'      : 'toggleState'
    'click #change-state'             : 'changeState'
    'click #add-note'                 : 'newNote'
    'click #submit-new-note'          : 'newNote'
    'click #create-new-cost_center'   : 'createNewCostCenter'
    'click #cancel-new-cost_center'   : 'createNewCostCenter'
    'click #submit-new-cost_center'   : 'createCostCenter'
    'click #new-quotation'            : 'createNewQuotation'
    'click .detail-label'             : 'toggleSection'
    'click #quotations-label'         : 'toggleQuotations'
    'click #clean_should_arrive_at'   : 'cleanShouldArriveAt'
    'click .closeRequest'             : 'closeRequest'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @fm = new App.Mixins.Form
    @flip = 1
    @flip1 = 1
    @collectionHelper = new App.Mixins.Collections
    @notes            = new App.Collections.Notes
    @uneditable_quotation_states = ['Esperando Autorización', 'Autorizado', 'Pedido Realizado', 'Cerrado', 'Rechazado', "No Entregado"]
    @accepted_quotation_states = ['Autorizado', 'Pedido Realizado', 'Cerrado', 'Rechazado', "No Entregado"]
    # Resuelvo el nombre del usuario creador
    @user     = App.users.get(@model.get('user_id'))
    # Resuelvo nombre del aprobador
    if @model.get('approver')?
      @approver = App.users.get(@model.get('approver'))
      @model.set('approved_by', @approver.get('name'))
    else
      @model.set('approved_by', "*** Sin Aprobar ***")
    # Resuelvo nombre del autorizador
    if @model.get('authorizer_id')?
      @authorizer = App.users.get(@model.get('authorizer_id'))
      @model.set('authorizer', @authorizer.get('name'))
    else
      @model.set('authorizer', "*** Sin Autorizar ***")
    # Resuelvo el nombre del Equipo
    @model.set('team', App.teams.getNameFromId(@user.get('team_id')))
    # Remove CreateQuotation Success
    @listenTo App.vent, "remove:createQuotation:success", (model) =>
      @$('#new-quotation').show()
    # Quotation Create Success
    @listenTo App.vent, "quotation:create:success", (model) => @addQuotation(model)
    # Remove CreateQuotation Success
    @listenTo App.vent, "remove:createQuotation:success", (model) => @model.quotations.remove(model)
    # Purchase Request Authorized Success
    @listenTo App.vent, "purchase_request:authorized:success", (model) =>
      @$('.accepted-quotation').show()
      @$('#quotations').slideUp('slow')
      @$('#quotations-label').html('Cotizaciones <i class="icon-filter icon-white"></i>')
      @flip1 = @flip1 + 1
      $("html, body").animate({ scrollTop: 405 }, "slow")
      @model.save {state: 'Autorizado', authorizer_id: App.user.id}, success: =>
        @$('#state').text('Autorizado')
        @$('#authorized_by').text(App.user.get('name'))
        view = new App.Views.ShowQuotation(model: model)
        App.pushToAppendedViews(view)
        @$('#accepted-quotation').append(view.render().el).hide().slideDown('slow')
        @$('.authorized').show()
        view.hideCloseButton()
        view.paintSelected()
    this
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    $(@el).html(@template(model: @model))
    @$('.user').text(@user.get('name'))
    @$('#detail').html(@model.get('detail'))
    @$('.compras').hide()
    # Si el usuario es supervisor
    @supervisorView()
    # Si el usuario pertenece a compras
    @comprasView()
    # Si el estado del pedido es "Cerrado"
    @closedView()
    # Si el estado del pedido es "Rechazado"
    @rejectedView()
    # Notas adjuntas a la Orden de Compras
    @notes.fetch data: {table_name: 'purchase_request', table_name_id : @model.id}, success: => @notes.each @renderNote
    # Cotizaciones adjuntas a la Orden de Compras
    @model.quotations.fetch data: {purchase_request_id: @model.id}, success: => @model.quotations.each (model) => @appendQuotation(model)
    # si la orden de compra se encuentra en algun estado que no permita edicion
    @uneditableQuotation()
    # Si el usuario es gerente y el estado es "Esperando Autorización"
    @directorView()
    # inicializar datepicker en el boton
    @$('#set_should_arrive_at').datepicker().on 'changeDate', (ev) =>
      @$('#set_should_arrive_at').datepicker('hide')
      @model.save {should_arrive_at: @$('#set_should_arrive_at').data('date')}, success: =>
        @$('#should_arrive_at').text(@$('#set_should_arrive_at').data('date'))
        @$('#notice').html('')
        @fm.displayFlash 'success', "El campo 'Fecha Esperado' ha sido actualizado correctamente"
    this

  directorView: ->
    if App.user.get('director') == true and @model.get('state') == "Esperando Autorización"
      @$('.director').show()
    if App.user.get('director') == true and @model.get('state') == "Autorizado"
      @$('.director').show()
      @$('.accepted-quotation').show()
    this

  supervisorView: ->
    if App.user.isSupervisor() and @model.get('state') == "Esperando Aprobación"
      @$('#approve-purchase-request').show()
      @$('#reject-purchase-request').show()
    this

  comprasView: ->
    if App.user.get('compras') == true
      @$('#compras-row').show()
      @$('.compras').show()
      if @accepted_quotation_states.indexOf(@model.get('state')) > -1
        @$('.accepted-quotation').show()
    this

  uneditableQuotation: ->
    if @uneditable_quotation_states.indexOf(@model.get('state')) > -1
      @$('#new-quotation').hide()
    this

  closedView: ->
    if @model.get('state') == 'Cerrado'
      @$('#stamp').removeClass().addClass('pr_status-Cerrado pull-right')
      @$('#state').text('Cerrado')
      @$('.well label').text('Cerrado')
      @$('.hideable').hide()
    this

  rejectedView: ->
    if @model.get('state') == 'Rechazado'
      @$('#stamp').removeClass().addClass('pr_status-Rechazado pull-right')
      @$('#state').text('Rechazado')
      @$('.well label').text('Rechazado')
      @$('.hideable').hide()
    this

  appendQuotation: (model) =>
    if @model.get('state') == "Esperando Autorización"
      model.set('can_be_selected', true)
    view = new App.Views.ShowQuotation(model: model)
    App.pushToAppendedViews(view)
    if model.get('selected') == true
      @$('#accepted-quotation').append(view.render().el)
      @$('#quotations').hide()
      @$('#quotations-label').html('Cotizaciones <i class="icon-filter icon-white"></i>')
      @$('.authorized').show()
      @flip1 = @flip1 + 1
    else
      @$('#quotations').append(view.render().el)
    if @uneditable_quotation_states.indexOf(@model.get('state')) > -1
      view.hideCloseButton()
    this
########################################################################################################################

############################################# $ Render Note $ ##########################################################
  renderNote: (note) =>
    view = new App.Views.NoteShow(model: note)
    App.pushToAppendedViews(view)
    @$('#notes').append(view.render().el)
    view.hideCloseButton()
    this
########################################################################################################################

######################################### $ Toggle Cost Center $ #######################################################
  toggleState: (e) ->
    e.preventDefault() if e?
    @$('.state').toggle()
    @$('#state_list').val(@model.get('state'))
    this
########################################################################################################################

######################################### $ Change Cost Center $ #######################################################
  changeState: (e) ->
    e.preventDefault()
    App.vent.trigger "hide:select-quotation-button"
    App.vent.trigger "selected:quotation:success"
    @$('#new-quotation').show()
    newState = @$('#state_list').val()
    if newState == '' then return @toggleState()
    @toggleState()
    @$('#state').text(newState)
    if newState == 'Aprobado' then return @approveRequest
    if newState == 'Rechazado' then return @rejectRequest
    if newState == 'Pedido Realizado'
      unless Date.parse($('#should_arrive_at').text()) > 0
        @fm.displayFlash('warning', "ATENCION! El campo 'Fecha Esperada' esta vacío. Por favor completelo.", 20000)
    if @uneditable_quotation_states.indexOf(newState) > -1
      @$('#new-quotation').hide()
      @$('.close-quotation').hide()
      App.vent.trigger "show:select-quotation-button"
      return @updateRequest(newState)
    @updateRequest(newState)
    this
########################################################################################################################

######################################### $ Toggle Cost Center $ #######################################################
  toggleCostCenter: (e) ->
    e.preventDefault() if e?
    @$('.cost_center').toggle()
    @$('#cost_center_list').val(@model.get('cost_center'))
    this
########################################################################################################################

######################################### $ Change Cost Center $ #######################################################
  changeCostCenter: (e) ->
    e.preventDefault()
    newCost = @$('#cost_center_list').val()
    if newCost == '' then return @toggleCostCenter()
    @toggleCostCenter()
    @model.set('cost_center', newCost)
    @model.save null, success: =>
      @fm.displayFlash('success', "El Centro de Costo ha cambiado a #{newCost}", 2500)
      @$('#cost_center').text(newCost)
      @$('#cost_center_list').append("<option>#{newCost}</option>")
    this
########################################################################################################################

###################################### $ Previous Purchase Request $ ###################################################
  prevPurchaseRequest: ->
    index = @collectionHelper.getModelId(@model, App.purchaseRequests)
    collectionSize = App.purchaseRequests.length
    if index == 0
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[(collectionSize-1)]
    else
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[(index - 1)]
########################################################################################################################

######################################## $ Next Purchase Request $ #####################################################
  nextPurchaseRequest: ->
    index = @collectionHelper.getModelId(@model, App.purchaseRequests)
    collectionSize = App.purchaseRequests.length
    if index == collectionSize-1
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[0]
    else
      App.vent.trigger "purchase_requests:show", App.purchaseRequests.models[(index + 1)]
########################################################################################################################

########################################### $ Approve Request $ ########################################################
  approveRequest: (e) ->
    e.preventDefault() if e?
    #@model.set('state', 'Aprobado')
    #@model.set('approver', App.user.id)
    @model.save {state: 'Aprobado', approver: App.user.id},  success: =>
      $("html, body").animate({ scrollTop: 0 }, "fast")
      $('.well').effect("bounce", { times:7 }, 500);
      @fm.displayFlash('success', 'El Pedido de Compra ha sido aprobado', 10000)
      @$('.label-status').text('Aprobado')
      @$('[class^="pr_status-"]').removeClass().addClass('pr_status-Aprobado pull-right')
      @$('#state').text('Aprobado')
      @$('#approve-purchase-request').hide()
      @$('#reject-purchase-request').hide()
      @$('#approver').text(App.user.get('name'))
########################################################################################################################

############################################ $ Reject Request $ ########################################################
  rejectRequest: (e) ->
    e.preventDefault() if e?
    @model.save {state: 'Rechazado', approver: App.user.id},  success: =>
      $("html, body").animate({ scrollTop: 0 }, "fast")
      $('.well').effect("bounce", { times:7 }, 500);
      @fm.displayFlash('alert', 'El Pedido de Compra ha sido Rechazado', 10000)
      @$('.label-status').text('Rechazado')
      @$('[class^="pr_status-"]').removeClass().addClass('pr_status-Rechazado pull-right')
      @$('#state').text('Rechazado')
      @$('#approve-purchase-request').hide()
      @$('#reject-purchase-request').hide()
      @$('#approver').text(App.user.get('name'))
      @$('.hideable').hide()
      this
########################################################################################################################

########################################### $ Update Request $ ########################################################
  updateRequest: (state) ->
    #@model.set('state', state)
    @model.save {'state', state}, success: =>
      @fm.displayFlash('success', "El estado ha cambiado a #{state}", 2500)
      @$('.label-status').text(state)
      @$('#status').text(state)
########################################################################################################################

############################################## $ New Note $ ############################################################
  newNote: (e) ->
    e.preventDefault() if e?
    newNote = @$('#new-note').val()
    if newNote == "" then return @
    @$('#new-note').val('')
    model = new App.Models.Note
    attributes =
      note:
        content       : newNote
        user_id       : App.user.id
        table_name    : 'purchase_request'
        table_name_id : @model.id
    model.save attributes, success: =>
      view = new App.Views.NoteShow(model: model)
      App.pushToAppendedViews(view)
      @$('#notes').append(view.render().el)
    this
########################################################################################################################

######################################## $ Create New Cost Center $ ####################################################
  createNewCostCenter: (e) ->
    e.preventDefault() if e?
    @$('#new-cost_center-input').toggle()
    @$('#edit-cost_center').toggle()
    @$('#cost_center').toggle()
    @$('#create-new-cost_center').toggle()
    @$('#submit-new-cost_center').toggle()
    @$('#cancel-new-cost_center').toggle()
    this
########################################################################################################################

########################################## $ Create Cost Center $ ######################################################
  createCostCenter: (e) ->
    e.preventDefault() if e?
    newCostCenter = @$('#new-cost_center-input').val()
    if newCostCenter == "" then return @createNewCostCenter()
    @$('#submit-new-cost_center').val('')
    model = new App.Models.FormHelper
    attributes =
      form_helper:
        column       : 'cost_center'
        value        : newCostCenter
    model.save attributes, success: =>
      @model.set('cost_center', newCostCenter)
      @model.save null, success: =>
        @$('#new-cost_center-input').val('')
        @createNewCostCenter()
        @fm.displayFlash('success', "Se ha creado el Centro de Costos '#{newCostCenter}' y se ha asignado a esta Solicitud", 2500)
        @$('#cost_center').text(newCostCenter)
        @$('#cost_center_list').append("<option>#{newCostCenter}</option>")
    this
########################################################################################################################

######################################## $ Create New Quotation $ ######################################################
  createNewQuotation: (e) ->
    e.preventDefault() if e?
    model = new App.Models.Quotation()
    model.set('purchase_request_id', @model.id)
    view = new App.Views.CreateQuotation(model: model)
    App.pushToAppendedViews(view)
    @$('#quotations').prepend(view.render().el)
    @$('#new-quotation').hide()
    this
########################################################################################################################

########################################## $ Add Quotations $ ##########################################################
  addQuotation: (model) =>
    @model.quotations.add(model)
    model.set('purchase_request_state', @model.get('state'))
    view = new App.Views.ShowQuotation(model: model)
    App.pushToAppendedViews(view)
    @$('#quotations').append(view.render().el)
    @$('#new-quotation').show()
    this
########################################################################################################################

############################################ $ Toggle Section $ ########################################################
  toggleSection: ->
    @flip = @flip + 1
    @$('.detail-box').slideToggle('slow')
    if @flip % 2 == 0
      @$('.detail-label').html('Detalle <i class="icon-filter icon-white"></i>')
    else
      @$('.detail-label').html('Detalle')
    this
########################################################################################################################

########################################### $ Toggle Quotations $ ######################################################
  toggleQuotations: ->
    @flip1 = @flip1 + 1
    @$('#quotations').slideToggle('slow')
    if @flip1 % 2 == 0
      @$('#quotations-label').html('Cotizaciones <i class="icon-filter icon-white"></i>')
    else
      @$('#quotations-label').html('Cotizaciones')
    this
########################################################################################################################

######################################### $ Clean SHould Arrive At $ ###################################################
  cleanShouldArriveAt: (e) ->
    e.preventDefault if e?
    result = confirm("Esta seguro que desea eliminar la Fecha Esperada?")
    if result
      @model.save {should_arrive_at: null}, success: =>
        @$('#should_arrive_at').text('***')
        @fm.displayFlash('success', "El campo 'Fecha Esperada' se ha eliminado correctamente")
    this
########################################################################################################################

######################################### $ Clean SHould Arrive At $ ###################################################
  closeRequest: (e) ->
    e.preventDefault if e?
    switch e.currentTarget.id
      when 'delivered'
        @model.save {state: 'Cerrado'}, success: =>
          @fm.displayFlash('success', "El pedido se ha entregado correctamente y su estado es ahora: 'Cerrado'")
          $("html, body").animate({ scrollTop: 0 }, "fast")
          $('.well').effect("bounce", { times:5 }, 500);
          @$('#stamp').removeClass().addClass('pr_status-Cerrado pull-right')
          @$('#state').text('Cerrado')
          @$('.well label').text('Cerrado')
          @$('.btn-mini').hide()
          @$('#nav-next-purchase-request').show()
          @$('#nav-prev-purchase-request').show()
          @$('#confirm_delivery_modal').modal('toggle')
          @$('#received-purchase-request').hide()
        break
      when 'not_delivered'
        @$('#confirm_delivery_modal').modal('toggle')
        @$('#leave_note_modal').modal('toggle')
        break
      when 'leave_note'
        @$('#confirm_delivery_note_modal').modal('toggle')
        @$('#leave_note_modal').modal('toggle')
        break
      when 'dont_leave_note'
         @model.save {state: 'No Entregado'}, success: =>
          @$('#state').text('No Entregado')
          @$('.well label').text('No Entregado')
          @$('#leave_note_modal').modal('toggle')
          @$('#received_purchase_request').hide()
          @fm.displayFlash('alert', "El pedido no ha sido entregado correctamente. Su estado ha cambiado a 'No Entregado' y se le ha enviado una notificación al departamento de compras", 20000)
         break
      when 'cancel_note'
        @model.save {state: 'No Entregado'}, success: =>
          @$('#state').text('No Entregado')
          @$('.well label').text('No Entregado')
          @$('#confirm_delivery_note_modal').modal('toggle')
          @$('#received_purchase_request').hide()
          @fm.displayFlash('alert', "El pedido no ha sido entregado correctamente. Su estado ha cambiado a 'No Entregado' y se le ha enviado una notificación al departamento de compras", 20000)
        break
      when 'confirm_note'
        newNote = @$('#delivery_note').val()
        unless newNote == ""
          @$('#delivery_note').val('')
          model = new App.Models.Note
          attributes =
            note:
              content       : newNote
              user_id       : App.user.id
              table_name    : 'purchase_request'
              table_name_id : @model.id
          model.save attributes, success: =>
            view = new App.Views.NoteShow(model: model)
            App.pushToAppendedViews(view)
            @$('#notes').append(view.render().el)
            view.hideCloseButton()
        @model.save {state: 'No Entregado'}, success: =>
          @$('#state').text('No Entregado')
          @$('.well label').text('No Entregado')
          @$('#confirm_delivery_note_modal').modal('toggle')
          @$('#received_purchase_request').hide()
          @fm.displayFlash('alert', "El pedido no ha sido entregado correctamente. Su estado ha cambiado a 'No Entregado' y se le ha enviado una notificación al departamento de compras. Puede ver su comentario en la sección de 'Notas' más abajo.", 20000)
        break
    this
########################################################################################################################
