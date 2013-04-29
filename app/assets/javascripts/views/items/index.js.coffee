class App.Views.ItemIndex extends Backbone.View
  template: JST['items/index']
  className: 'span12'
  name: 'IndexItem'

  filtered: false
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @collection = App.items
    @fetchItems = _.debounce(@fetchItems, 300)
    @listenTo App.vent, 'update:page', (page) =>
      @$('.page').removeClass("label label-info")
      @$("*[data-pages='#{page}']").addClass("label label-info")
      @$('#pagination-end').removeClass('label label-info')
########################################################################################################################

############################################### $ Events $ #############################################################
  events:
    'click #new-item'             : 'newItem'
    'click #fetch-items'          : 'fetchItems'
    'click th'                    : 'sortItems'
    'click .pagination a'         : 'changePage'
    'mouseover .page'             : 'paginationHoverIn'
    'mouseout .page'              : 'paginationHoverOut'
    'click ul.dropdown-menu li a' : 'generalOrder'
########################################################################################################################

############################################### $ Render $ #############################################################
  render: ->
    $(@el).html(@template())
    @update(1)
    @pagination()
    this
########################################################################################################################

############################################# $ Pagination $ ###########################################################
  paginationHoverIn: (e) ->
    page = e.currentTarget.dataset["pages"]
    @$('.page').removeClass('pagination-hover')
    @$("[data-pages=#{page}]").addClass('pagination-hover').css('color', '#FFFFFF')
    this

  paginationHoverOut: (e) ->
    @$('.page').removeClass('pagination-hover').css('color', 'rgb(0,136,204)')
    @$('li a.label-info').css('color', '#FFFFFF')
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
########################################################################################################################

################################################# $ Sort $ #############################################################
  removeChevron: ->
    @$(".icon-chevron-up").remove()
    @$(".icon-chevron-down").remove()

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
      @$("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-up pull-right"></i>' )
    else
      @$("th[data-sort=#{sortVar}]").append( '<i class="icon-chevron-down pull-right"></i>' )
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
    @paginationHoverOut(1)

  generalOrder: (e) ->
    e.preventDefault() if e?
    column = e.currentTarget.dataset['sort']
    text = e.currentTarget.text
    @$('#search-column').html("Columna: #{text}" + '<span class="caret"></span>')
    if App.items.length == 0
      App.items.fetch success: => @generalOrderAppend(column)
    else
      @generalOrderAppend(column)
    this

  generalOrderAppend: (column) =>
    App.items.sortVar = column
    App.items.sortVarType = 'string'
    App.items.sortMethod = 'lTH'
    console.log App.items
    App.items.sort()
    App.vent.trigger 'update:items:success'
    App.items.page(1).forEach (item) => @appendItem(item)
    @pagination()
    App.vent.trigger 'update:page', 1
    this
########################################################################################################################

############################################# $ Manage Items $ #########################################################
  appendItem: (model) =>
    view = new App.Views.Item(model: model, collection: App.items)
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