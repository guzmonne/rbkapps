class App.Views.PurchaseRequestShow extends Backbone.View
  template: JST['purchase_request/show']
  className: 'span12'
  name: 'ShowPurchaseRequest'
########################################################################################################################

################################################ $ Events $ ############################################################
  events:
    'click #nav-prev-purchase-request': 'prevPurchaseRequest'
    'click #nav-next-purchase-request': 'nextPurchaseRequest'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
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
    if App.user.get('compras') == true
      @$('#compras-row').show()
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
