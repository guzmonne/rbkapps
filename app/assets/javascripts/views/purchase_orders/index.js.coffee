class App.Views.PurchaseOrderIndex extends Backbone.View
  template: JST['purchase_orders/index']
  className: 'span12'
  name: 'IndexPurchaseOrder'
########################################################################################################################

############################################## $ Events $ ##############################################################
  #events:
########################################################################################################################

############################################ $ Initialize $ ############################################################
  initialize: ->
    @fetchPurchaseOrders = _.debounce(@fetchPurchaseOrders(), 300);
    @collection = App.purchaseOrders
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    $(@el).html(@template())
    @collection.each(@appendPurchaseOrder)
    this
########################################################################################################################

######################################## $ Append Purchase Request $ ###################################################
  appendPurchaseOrder: (model) =>
    view = new App.Views.PurchaseOrder(model: model)
    App.pushToAppendedViews(view)
    @$('#purchase-orders').append(view.render().el)
    this
########################################################################################################################

########################################## $ Fetch Purchase Request $ ##################################################
  fetchPurchaseOrders: (e) ->
    e.preventDefault() if e?
    App.vent.trigger 'update:purchase_orders:success'
    @$('#fetch-purchase_orders').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.purchaseOrders.fetch data: {user_id: App.user.id}, success: =>
      @$('#fetch-purchase_orders').html('Actualizar').removeClass('loading')
      App.purchaseOrders.each(@appendPurchaseOrders)
    this
########################################################################################################################
