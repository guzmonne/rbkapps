class App.Views.DeliveryIndex extends Backbone.View
  template: JST['deliveries/index']
  className: 'span12'
  name: 'IndexDelivery'

  filtered: false

  initialize: ->
    @collection       = new App.Collections.Deliveries
    @searchCollection = new App.Collections.Deliveries
    @lastSearch = []
    @fetchDeliveries = _.debounce(@fetchDeliveries, 300)
    @listenTo App.vent, 'update:page', (page) =>
      @$('.page').removeClass("label label-info")
      @$("*[data-pages='#{page}']").addClass("label label-info")
      @$('#pagination-end').removeClass('label label-info')
    @listenTo App.vent, 'remove:delivery:success', (model) => App.deliveries.remove(model)

  events:
    'click #new-delivery'     : 'newDelivery'
    'click #fetch-deliveries' : 'fetchDeliveries'
    'click th'                : 'sortDeliveries'
    'submit .form-search'     : 'searchDelivery'
    'click .close'            : 'closePopover'
    'click .drop-columns'     : 'updateSearchColumn'
    'click #search-undo'      : 'searchUndo'
    'focus #search-input'     : 'searchTypeahead'
    'click .pagination a'     : 'changePage'
    'mouseover .page'         : 'paginationHoverIn'
    'mouseout .page'          : 'paginationHoverOut'

  render: ->
    $(@el).html(@template())
    @update(1)
    @pagination()
    this

  paginationHoverIn: (e) ->
    page = e.currentTarget.dataset["pages"]
    @$('.page').removeClass('pagination-hover')
    @$("[data-pages=#{page}]").addClass('pagination-hover')
    this

  paginationHoverOut: (e) ->
    @$('.page').removeClass('pagination-hover')
    this

  pagination: ->
    if @filtered == false then @collection = App.deliveries
    @removeChevron()
    @$('.page').remove()
    l = @collection.length
    if l > 0
      @$('.pagination').show()
      pages = l / @collection.perGroup
      if l % @collection.perGroup > 0 then pages = pages + 1
      for i in [1..pages]
        @$('#pagination-end').before('<li><a href="#" class="page" data-pages="' + i + '">' + i + '</a></li>')
      @$('#pagination-end').data('pages', pages)

  removeChevron: ->
    @$(".icon-chevron-up").remove()
    @$(".icon-chevron-down").remove()

  changePage: (e) ->
    e.preventDefault()
    @removeChevron()
    if e.currentTarget.text == "Next"
      current_page = @collection.currentPage
      pages = parseInt @$('#pagination-end').data('pages')
      if current_page == pages
        return @update(1)
      else
        return @update(current_page + 1)
    else if e.currentTarget.text == "Prev"
      current_page = @collection.currentPage
      last_page = parseInt @$('#pagination-end').data('pages')
      if current_page == 1
        return @update(last_page)
      else
        return @update(current_page - 1)
    else
      return @update(parseInt e.currentTarget.text)

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
    @$('#fetch-deliveries').html(' <i class="icon-load"></i>  Actualizando').addClass('loading')
    App.deliveries.fetch success: =>
      @$('#fetch-deliveries').html('Actualizar').removeClass('loading')
      @pagination()
      @update(1)
      @lastSearch = []
    this

  sortDeliveries: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar  =  @collection.sortVar
    @removeChevron()
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
    @update(@collection.currentPage, type, sortVar, method)

  update: (page, type, sortVar, method) ->
    oldSortVarType      = @collection.sortVarType
    oldSortVar          = @collection.sortVar
    oldSortMethod       = @collection.sortMethod
    if @filtered == false then @collection = App.deliveries
    @collection = @collection.page(page)
    @collection.currentPage = page
    if type? and sortVar? and method?
      @collection.setSortVariables(type, sortVar, method)
    else
      @collection.setSortVariables(oldSortVarType, oldSortVar, oldSortMethod)
    App.vent.trigger 'update:deliveries:success'
    App.vent.trigger 'update:page', page
    @collection.sort().each(@appendDelivery)

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
    $('#fetch-deliveries').hide()
    $('#search-undo').show()
    $('#search-column').removeClass('btn-success').addClass('btn-warning')
    @lastSearch.push attributes.column
    object = {}
    array = []
    if attributes.column == 'guide'
      object2 = {}
      object3 = {}
      object['guide'] = attributes.data
      object2['guide2'] = attributes.data
      object3['guide3'] = attributes.data
      array.push(App.deliveries.where(object))
      array.push(App.deliveries.where(object2))
      array.push(App.deliveries.where(object3))
    else
      object[attributes.column] = attributes.data
      array = App.deliveries.where(object)
    for model in array
      @searchCollection.add(model)
    @collection = @searchCollection
    @filtered = true
    @pagination()
    @update(1)
    @removeChevron()
    @searchCollection = new App.Collections.Deliveries

  searchUndo: (e) ->
    e.preventDefault()
    $('#search-column').removeClass('btn-warning').addClass('btn-success')
    @removeChevron()
    @filtered = false
    @pagination()
    @update(1)
    $('#search-undo').hide()
    $('#fetch-deliveries').show()
    @lastSearch = []

  searchTypeahead: ->
    $('#search-input').typeahead items: 20, source: => @searchValues()
    this

  searchValues: ->
    array = []
    column = @$('#search-column').data('column')
    if column == 'guide'
      for element in App.deliveries.pluckDistinct('guide')
        array.push element if element?
      for element in App.deliveries.pluckDistinct('guide2')
        array.push element if element?
      for element in App.deliveries.pluckDistinct('guide3')
        array.push element if element?
      return array
    else
      for element in App.deliveries.pluckDistinct(column)
        array.push element if element?
      return array



