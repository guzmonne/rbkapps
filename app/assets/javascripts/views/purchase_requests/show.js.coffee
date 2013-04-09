class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'row-fluid'
  name: 'ShowPurchaseRequest'
########################################################################################################################

################################################ $ Events $ ############################################################
  events:
    'click #nav-prev-purchase-request': 'prevPurchaseRequest'
    'click #nav-next-purchase-request': 'nextPurchaseRequest'
    'click #approve-purchase-request' : 'approveRequest'
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
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @fm = new App.Mixins.Form
    @flip = 1
    @collectionHelper = new App.Mixins.Collections
    @notes            = new App.Collections.Notes
    @user     = App.users.get(@model.get('user_id'))
    if @model.get('approver')?
      @approver = App.users.get(@model.get('approver'))
      @model.set('approved_by', @approver.get('name'))
    else
      @model.set('approved_by', "*** Sin Aprobar ***")
    @model.set('team', App.teams.getNameFromId(@user.get('team_id')))
    @listenTo App.vent, "remove:createQuotation:success", (model) =>
      @$('#new-quotation').show()
    @listenTo App.vent, "quotation:create:success", (model) => @addQuotation(model)
    @listenTo App.vent, "remove:createQuotation:success", (model) => @model.quotations.remove(model)
    this
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    $(@el).html(@template(model: @model))
    @$('.user').text(@user.get('name'))
    @$('#detail').html(@model.get('detail'))
    @$('.compras').hide()
    if App.user.isSupervisor() and @model.get('state') == "Esperando Aprobación"
      @$('#approve-purchase-request').show()
    if App.user.get('compras') == true
      @$('#compras-row').show()
      @$('.compras').show()
    @notes.fetch
      data:
        table_name    : 'purchase_request'
        table_name_id : @model.id
      success: =>
        @notes.each @renderNote
    this
########################################################################################################################

############################################# $ Render Note $ ##########################################################
  renderNote: (note) =>
    view = new App.Views.NoteShow(model: note)
    App.pushToAppendedViews(view)
    @$('#notes').append(view.render().el)
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
    newState = @$('#state_list').val()
    if newState == '' then return @toggleState()
    @toggleState()
    @$('#state').text(newState)
    switch newState
      when 'Aprobado'
        @approveRequest()
        break
      else
        @updateRequest(newState)
        break
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
    @model.set('state', 'Aprobado')
    @model.set('approver', App.user.id)
    @model.save null,  success: =>
      $("html, body").animate({ scrollTop: 0 }, "fast")
      $('.well').effect("bounce", { times:5 }, 500);
      @fm.displayFlash('success', 'El pedido de Compra ha sido aprobado', 10000)
      @$('.label-status').text('Aprobado')
      @$('[class^="pr_status-"]').removeClass().addClass('pr_status-Aprobado pull-right')
      @$('#status').text('Aprobado')
      @$('#approve-purchase-request').hide()
      @$('#approver').text(App.user.get('name'))
########################################################################################################################

########################################### $ Update Request $ ########################################################
  updateRequest: (state) ->
    @model.set('state', state)
    @model.save null,  success: =>
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
    view = new App.Views.CreateQuotation(model: model)
    App.pushToAppendedViews(view)
    @$('#quotations').prepend(view.render().el)
    @$('#new-quotation').hide()
    this
########################################################################################################################

########################################## $ Add Quotations $ ##########################################################
  addQuotation: (model) =>
    console.log model
    @model.quotations.add(model)
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