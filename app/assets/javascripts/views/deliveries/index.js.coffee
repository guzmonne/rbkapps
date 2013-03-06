class App.Views.DeliveryIndex extends Backbone.View
  template: JST['deliveries/index']
  className: 'span12'
  name: 'IndexDelivery'

  initialize: ->
    @collection = App.deliveries
    @searchCollection = new App.Collections.Deliveries
    @lastSearch = []

  events:
    'click #new-delivery'     : 'newDelivery'
    'click #fetch-deliveries' : 'fetchDeliveries'
    'click th'                : 'sortDeliveries'
    'submit .form-search'     : 'searchDelivery'
    'click .close'            : 'closePopover'
    'click .drop-columns'     : 'updateSearchColumn'
    'click #search-undo'      : 'searchUndo'
    'focus #search-input'     : 'searchTypeahead'

  render: ->
    $(@el).html(@template())
    @collection.each(@appendDelivery)
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
      @collection = App.deliveries
      App.deliveries.each(@appendDelivery)
      @lastSearch = []
    this

  sortDeliveries: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar = @collection.sortVar
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
    App.vent.trigger 'update:purchase_requests'
    @collection.each(@appendDelivery)

  searchDelivery: (e) ->
    e.preventDefault()
    return if e.currentTarget.id == "search-column"
    if $('#search-column').data('column') == ""
      $('#search-column').popover
        placement: 'bottom'
        title: '<h5>Atención<button class="close pull-right">&times;</button></h5>'
        html: true
        content:'<p class="text-warning">Seleccione una columna antes de buscar por favor.</p>'
      $('#search-column').popover('show')
      setTimeout( ->
        $('#search-column').popover('destroy')
      , 1500)
      return
    if App.deliveries.length == 0
      $('#fetch-deliveries').popover
        placement: 'right'
        title: '<h5>Atención<button class="close pull-right">&times;</button></h5>'
        html: true
        content:'<p class="text-warning">Actualize los datos antes de comenzar la busqueda por favor.</p>'
      $('#fetch-deliveries').popover('show')
      setTimeout( ->
        $('#fetch-deliveries').popover('destroy')
      , 1500)
      return
    attributes =
      column  : $('#search-column').data('column')
      data    : $('#search-input').val()
    @search(attributes)

  closePopover: (e) ->
    e.preventDefault()
    $('#search-column').popover('destroy')
    $('#fetch-deliveries').popover('destroy')


  updateSearchColumn: (e) ->
    e.preventDefault()
    $('#search-column').removeClass('btn-warning').addClass('btn-success')
    search  = e.currentTarget.dataset["search"]
    name    = e.currentTarget.innerHTML
    $('#search-column').data('column', search)
    $('#search-column').html( name + ' <span class="caret"></span>')

  search: (attributes) =>
    for element in @lastSearch
      if element == $('#search-column').data('column') then return
    $('#search-undo').show()
    $('#search-column').removeClass('btn-success').addClass('btn-warning')
    @lastSearch.push attributes.column
    object = {}
    object[attributes.column] = attributes.data
    array = @collection.where(object)
    for model in array
      @searchCollection.add(model)
    App.vent.trigger 'update:purchase_requests'
    @searchCollection.each(@appendDelivery)
    $("th[data-sort=#{@collection.sortVar}] i").remove()
    @collection = @searchCollection
    @searchCollection = new App.Collections.Deliveries

  searchUndo: (e) ->
    e.preventDefault()
    $('#search-column').removeClass('btn-warning').addClass('btn-success')
    $("th[data-sort=#{@collection.sortVar}] i").remove()
    App.vent.trigger 'update:purchase_requests'
    @collection = App.deliveries
    @collection.each @appendDelivery
    $('#search-undo').hide()
    @lastSearch = []

  searchTypeahead: ->
    $('#search-input').typeahead source: => @collection.pluckDistinct($('#search-column').data('column'))
    this




