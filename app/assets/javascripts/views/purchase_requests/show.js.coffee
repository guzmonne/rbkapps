class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'span12'
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
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @fm = new App.Mixins.Form
    @collectionHelper = new App.Mixins.Collections
    @user     = App.users.get(@model.get('user_id'))
    if @model.get('approver')?
      @approver = App.users.get(@model.get('approver'))
      @model.set('approved_by', @approver.get('name'))
    else
      @model.set('approved_by', "*** Sin Aprobar ***")
    @model.set('team', App.teams.getNameFromId(@user.get('team_id')))
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