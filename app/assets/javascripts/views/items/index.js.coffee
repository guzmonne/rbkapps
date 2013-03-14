class App.Views.ItemIndex extends Backbone.View
  template: JST['items/index']
  className: 'span12'
  name: 'IndexItem'

  filtered: false

  initialize: ->
    @collection = App.items
    @fetchItems = _.debounce(@fetchItems, 300)
    @listenTo App.vent, 'update:page', (page) =>
      @$('.page').removeClass("label label-info")
      @$("*[data-pages='#{page}']").addClass("label label-info")

  events:
    'click #new-item'         : 'newItem'
    'click #fetch-items'      : 'fetchItems'
    'click th'                : 'sortItems'
    'click .pagination a'     : 'changePage'

  render: ->
    $(@el).html(@template())
    @update(1)
    @pagination()
    this

  pagination: ->
    if @filtered == false then @collection = App.items
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

  appendItem: (model) =>
    view = new App.Views.Item(model: model)
    App.pushToAppendedViews(view)
    @$('#items').append(view.render().el)
    this

  newItem: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'items/new', trigger: true
    this

  fetchItems: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:items:success'
    @$('#fetch-items').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.items.fetch success: =>
      @$('#fetch-items').html('Actualizar').removeClass('loading')
      @pagination()
      @update(1)
    this

  sortItems: (e) ->
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
    if @filtered == false then @collection = App.items
    @collection = @collection.page(page)
    @collection.currentPage = page
    if type? and sortVar? and method?
      @collection.setSortVariables(type, sortVar, method)
    else
      @collection.setSortVariables(oldSortVarType, oldSortVar, oldSortMethod)
    App.vent.trigger 'update:items:success'
    App.vent.trigger 'update:page', page
    @collection.sort().each(@appendItem)