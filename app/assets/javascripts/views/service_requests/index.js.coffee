class App.Views.ServiceRequestsIndex extends Backbone.View
  template: JST['service_request/index']
  className: 'span12'
  name: 'ServiceRequestsUsers'

  initialize: ->
    @collection = App.serviceRequests
    @headers = []
    @counter = 0
    $(window).on "resize", =>
      @fixHeaders()
    @listenTo App.vent, 'service_requests:render:success', => @fixHeaders()

  events:
    'click #fetch-service_requests'  : 'fetchServiceRequests'
    'click #new-service-request'     : 'newServiceRequest'
    'click th'                       : 'sortServiceRequests'
    'focus #search-input'            : 'searchTypeahead'
    'click .drop-columns'            : 'updateSearchColumn'
    'click #search-button'           : 'filterServiceRequests'
    'click #search-undo'             : 'searchUndo'

  render: ->
    $(@el).html(@template())
    for i in [0..@$('th[data-sort]').length - 1]
      @headers.push @$(@$('th[data-sort]')[i]).data("sort")
    i = 0
    timer = setInterval( =>
      @fixHeaders()
      i++
      clearInterval(timer) if i == 10
    , 50)
    if App.categories.length > 0 and App.serviceRequests.length > 0
      @counter = 0
      App.serviceRequests.each(@appendServiceRequest)
    this

  remove: ->
    $(window).off "resize"
    super()

  fixHeaders: =>
    for header, i in @headers
      tdpadding = parseInt(@$("td[data-sort=#{header}]").css('padding'))
      tdwidth = parseInt(@$("td[data-sort=#{header}]").css('width'))
      @$("th[data-sort=#{header}]").css('padding', tdpadding)
      @$("th[data-sort=#{header}]").css('width', tdwidth)
      if (i+1) == @headers.length
        trwidth = @$("td[data-sort=#{header}]").parent().css('width')
        @$("th[data-sort=#{header}]").parent().parent().parent().css('width', trwidth)
        @$('.bodycontainer').css('height', window.innerHeight - ($('html').outerHeight() - @$('.bodycontainer').outerHeight() ) ) unless @collection.length == 0

  appendServiceRequest: (model) =>
    view = new App.Views.ServiceRequest(model: model)
    App.pushToAppendedViews(view)
    @$('#service_requests').append(view.render().el)
    @counter = @counter + 1
    if @counter == App.serviceRequests.length
      App.vent.trigger 'service_requests:render:success'
      @counter = 0
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

  updateSearchColumn: (e) ->
    e.preventDefault() if e?
    @$('#search-column').removeClass('btn-warning').addClass('btn-success')
    search  = e.currentTarget.dataset["search"]
    name    = e.currentTarget.innerHTML
    @$('#search-column').data('column', search)
    @$('#search-column').html( name + ' <span class="caret"></span>')

  searchTypeahead: ->
    @$('#search-input').typeahead items: 20, source: => @searchValues()
    this

  searchValues: ->
    array = []
    column = @$('#search-column').data('column')
    for element in App.serviceRequests.pluckDistinct(column)
      array.push element if element?
    return array

  filterServiceRequests: (e) ->
    e.preventDefault()
    filter = @$('#search-column').data('column')
    return if filter == ""
    object = {}
    array  = []
    object[filter] = @$('#search-input').val()
    array = App.serviceRequests.where(object)
    App.vent.trigger 'update:purchase_requests:success'
    for model in array
      @appendServiceRequest(model)
    @$('#fetch-service_requests').hide()
    @$('#search-undo').show()
    @$('#search-column').removeClass('btn-success').addClass('btn-warning')

  searchUndo: (e) ->
    e.preventDefault()
    @$('#search-column').removeClass('btn-warning').addClass('btn-success')
    @$('#search-undo').hide()
    @$('#fetch-service_requests').show()
    App.serviceRequests.each(@appendServiceRequest)