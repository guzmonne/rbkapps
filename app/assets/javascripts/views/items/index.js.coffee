class App.Views.ItemIndex extends Backbone.View
  template: JST['items/index']
  className: 'span12'
  name: 'IndexItem'

  filtered: false
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @counter = 0
    @fh = new App.Mixins.Form
    @collection = App.items
    @fetchItems = _.debounce(@fetchItems, 300)
    @headers = []
    $(window).on "resize", =>
      @fixHeaders() unless @collection.length == 0
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
    'focus #search-input'         : 'searchTypeahead'
    'click #search-button'        : 'searchItem'
    'click #search-undo'          : 'searchUndo'
    'keydown :input'              : 'keyDownManager'
    'click #massive-items'        : 'massiveItems'
    'click #submit-massive-items' : 'submitMassiveItems'
    'change #select_file'         : 'changeSelectFile'
########################################################################################################################

############################################### $ Render $ #############################################################
  render: ->
    $(@el).html(@template())
    for i in [0..@$('th[data-sort]').length - 1]
      @headers.push @$(@$('th[data-sort]')[i]).data("sort")
    App.vent.trigger 'update:items:success'
    @pagination()
    @update(1)
    i = 0
    timer = setInterval( =>
      @fixHeaders()
      i++
      clearInterval(timer) if i == 10
    , 50)
    this

  remove: ->
    $(window).off "resize"
    super()
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

  update: (page, type, sortVar, method) =>
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
    @counter = 0
    @collection.sort().each(@appendItem)
    @paginationHoverOut(1)

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

  generalOrder: (e) ->
    e.preventDefault() if e?
    column = e.currentTarget.dataset['sort']
    text = e.currentTarget.text
    @$('#search-column').html("Columna: #{text}  " + '<span class="caret"></span>')
    if App.items.length == 0
      App.items.fetch success: => @generalOrderAppend(column)
    else
      @generalOrderAppend(column)
    this

  generalOrderAppend: (column) =>
    App.items.sortVar = column
    App.items.sortVarType = 'string'
    App.items.sortMethod = 'lTH'
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
    @fixHeaders()
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
########################################################################################################################

########################################### $ Search Type Ahead $ ######################################################
  searchTypeahead: ->
    if App.items.length == 0 then return @fh.displayFlash("alert", "No se han cargado elementos en la tabla.")
    @$('#search-input').typeahead items: 20, source: => @searchValues()
    this

  searchValues: ->
    array = []
    for element in App.items.pluckDistinct('code')
      array.push element if element?
    return array
########################################################################################################################

############################################### $ Search Item $ ########################################################
  searchItem: (e) ->
    e.preventDefault() if e?
    @$('#notice').html('')
    if App.items.length == 0 then return @fh.displayFlash("alert", "No se han cargado elementos en la tabla.")
    code = @$('#search-input').val()
    items = App.items.where({code: code})
    if items.length == 0 then return @fh.displayFlash('alert', "No se han encontrado artículos que contengan el codigo: #{code}")
    @$('#search-input').val('')
    App.vent.trigger 'update:items:success'
    @$('#search-undo').show()
    @$('#fetch-items').hide()
    for item in items
      @appendItem(item)
    @pagination()
    return this

  searchUndo: (e) ->
    e.preventDefault() if e?
    @$('#search-undo').hide()
    @$('#fetch-items').show()
    @pagination()
    @update(1)

  keyDownManager: (e) ->
    switch e.keyCode
      when 13 # Enter
        switch e.currentTarget.id
          when "search-input"
            @searchItem()
            break
    this
########################################################################################################################

############################################### $ Search Item $ ########################################################
  massiveItems: (e) ->
    e.preventDefault() if e?
    @$('#massive-items-modal').modal('toggle');

  submitMassiveItems: (e) ->
    e.preventDefault()
    file = @$(':file')[0].files[0]
    formData = new FormData($('form')[0])
    if  file.name == ""
      @fh.displayFlash('alert', "Debe seleccionar un documento CSV delimitado por comas.")
      return @massiveItems(e)
    $.ajax({
      url: '/api/items/import'
      type: 'POST'
      success: => @handleSuccess(data, status)
      data: formData
      cache: false
      contentType: false
      processData: false
    })

  handleSuccess: (data, status) ->
    @fh.displayFlash('success', "La carga masiva se ha realizado con exito. Actualice los datos para ver los nuevos registros.", 10000)
    @massiveItems()

  changeSelectFile: (e) ->
    file = @$(':file')[0].files[0]
    name = file.name
    size = file.size
    type = file.type
    a = [];
    unless type == 'application/vnd.ms-excel' then a.push('Solo se aceptan archivos CSV delimitado por comas.')
    if a.length > 0 then return @fh.displayListFlash('error', a, 3000, '#massive-items-notice')









