class App.Views.DeliveryIndex extends Backbone.View
  template: JST['deliveries/index']
  className: 'span12'
  name: 'IndexDelivery'

  initialize: ->
    App.deliveries == @collection

  events:
    'click #new-delivery'     : 'newDelivery'
    'click #fetch-deliveries' : 'fetchDeliveries'
    'click th'                : 'sortDeliveries'

  render: ->
    $(@el).html(@template())
    App.deliveries.each(@appendDelivery)
    this

  appendDelivery: (model) =>
    view = new App.Views.Delivery(model: model)
    App.pushToAppendedViews(view)
    @$('#deliveries').append(view.render().el)
    this

  newDelivery: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'deliveries/new', trigger: true
    this

  fetchDeliveries: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:purchase_requests'
    @$('#fetch-deliveries').html(' <i class="icon-load"></i>  Actualizando').addClass('loading')
    App.deliveries.fetch success: =>
      @$('#fetch-deliveries').html('Actualizar').removeClass('loading')
      App.deliveries.each(@appendDelivery)
    this

  sortDeliveries: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar = App.deliveries.sortVar
    $("th[data-sort=#{oldVar}] i").remove()
    if sortVar == oldVar
      if App.deliveries.sortMethod == 'lTH'
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
    App.deliveries.sortVarType= type
    App.deliveries.sortVar    = sortVar
    App.deliveries.sortMethod = method
    App.deliveries.sort()
    App.vent.trigger 'update:purchase_requests'
    App.deliveries.each(@appendDelivery)





