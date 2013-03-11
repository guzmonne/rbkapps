class App.Views.PurchaseRequestIndex extends Backbone.View
  template: JST['purchase_request/index']
  className: 'span12'
  name: 'IndexPurchaseRequest'

  events:
    'click #new-purchase-request'        : 'newPurchaseRequest'
    'click #fetch-purchase_requests'     : 'fetchPurchaseRequests'
    'click th'                           : 'sortPurchaseRequests'

  initialize: ->
    @fetchPurchaseRequests = _.debounce(@fetchPurchaseRequests, 300);
    @collection = App.purchaseRequests

  render: ->
    $(@el).html(@template())
    @collection.each(@appendPurchaseRequest)
    this

  appendPurchaseRequest: (model) =>
    view = new App.Views.PurchaseRequest(model: model)
    App.pushToAppendedViews(view)
    @$('#purchase-requests').append(view.render().el)
    this

  newPurchaseRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_request/new', trigger: true
    this

  fetchPurchaseRequests: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:purchase_requests:success'
    @$('#fetch-purchase_requests').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.purchaseRequests.fetch data: {user_id: App.user.id}, success: =>
      @$('#fetch-purchase_requests').html('Actualizar').removeClass('loading')
      App.purchaseRequests.each(@appendPurchaseRequest)
    this

  sortPurchaseRequests: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar  =  @collection.sortVar
    $("th[data-sort=#{oldVar}] i").remove()
    if sortVar == oldVar
      if @collection.sortMethod == 'lTH'
        @sort(sortVar, 'hTL', 'down', type )
      else
        @sort(sortVar, 'lTH', 'up', type )
    else
      @sort(sortVar, 'lTH', 'up', type, oldVar )

  sort: (sortVar, method, direction, type, oldVar = null ) ->
    if oldVar == null then oldVar = sortVar
    if direction == 'up'
      $("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-up pull-right"></i>' )
    else
      $("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-down pull-right"></i>' )
    @collection.sortVarType= type
    @collection.sortVar    = sortVar
    @collection.sortMethod = method
    @collection.sort()
    App.vent.trigger 'update:purchase_requests:success'
    @collection.each(@appendPurchaseRequest)


