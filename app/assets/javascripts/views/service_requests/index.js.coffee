class App.Views.ServiceRequestsIndex extends Backbone.View
  template: JST['service_request/index']
  className: 'span12'
  name: 'ServiceRequestsUsers'

  initialize: ->
    @collection = App.serviceRequests

  events:
    'click #fetch-service_requests'  : 'fetchServiceRequests'
    'click #new-service-request'     : 'newServiceRequest'
    'click th'                       : 'sortServiceRequests'

  render: ->
    $(@el).html(@template())
    if App.categories.length > 0 and App.serviceRequests.length > 0
      App.serviceRequests.each(@appendServiceRequest)
    this

  appendServiceRequest: (model) =>
    view = new App.Views.ServiceRequest(model: model)
    App.pushToAppendedViews(view)
    @$('#service_requests').append(view.render().el)
    this

  statusFilter: (e) ->
    e.preventDefault()
    console.log $(e.currentTarget)[0]
    if e.currentTarget.dataset["selected"] == true
      $(e.target).data("selected", false)
      $(e.target).removeClass("btn-inverse").addClass('btn-warning')
    else
      $(e.target).data("selected", true)
      $(e.target).removeClass("btn-warning").addClass('btn-inverse')
    #App.vent.trigger 'update:purchase_requests:success'

  fetchServiceRequests: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:purchase_requests:success'
    @$('#fetch-service_requests').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.categories.fetch success: =>
      App.serviceRequests.fetch data:{user_id: App.user.id}, success: =>
        @$('#fetch-service_requests').html('Actualizar').removeClass('loading')
        return if App.serviceRequests.length == 0
        App.serviceRequests.each(@appendServiceRequest)
        @$('#status-filter').show()
    this

  newServiceRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'service_requests/create', trigger = true
    this

  sortServiceRequests: (e) ->
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
    @collection.each(@appendServiceRequest)
