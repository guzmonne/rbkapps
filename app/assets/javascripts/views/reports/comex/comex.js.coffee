class App.Views.ComexReports extends Backbone.View
  template: JST['reports/comex/main']
  itemsStatus: JST['reports/comex/items_status']
  daysToDispatch: JST['reports/comex/days_to_dispatch']


  events:
    'click ul.dropdown-menu li a'     : 'customSelect'
    'keydown .no_typing'              : 'noTyping'
    'keyup .no_typing'                : 'noTyping'
    'click .run_report'               : 'runReport'
    'click th'                        : 'sortItems'

  initialize: ->
    @reportName = ''
    @collection = new App.Collections.Items
    @deliveries = new App.Collections.Deliveries
    @fh = new App.Mixins.Form

  render: ->
    $(@el).html(@template())
    this

  customSelect: (e) ->
    text = e.currentTarget.text
    id = e.currentTarget.dataset["id"]
    switch id
      when 'report_name'
        @reportName = e.currentTarget.dataset['reportName']
        @$('#report_name').val(text)
        @showFilters()
        @$('#report').hide()
        break
      when 'brand', 'season', 'entry'
        @$('#' + id).val(text)
        break
    this

  showFilters: ->
    @$('.filter').hide()
    @$('#' + @reportName).fadeIn('slow')
    this

  noTyping: (e) ->
    e.preventDefault()
    id = e.currentTarget.id
    @$('#' + id).val('')
    this

  runReport: (e) ->
    e.preventDefault()
    @$('#notice').html('')
    App.vent.trigger "new:report:success"
    view  = new App.Views.Loading
    App.pushToAppendedViews(view)
    switch @reportName
      when 'items_status'
        @$('#report').show().html(@itemsStatus())
        @$('#report').show().append(view.render().el)
        @itemsStatusReport()
        break
      when 'days_to_dispatch'
        @$('#report').show().html(@daysToDispatch())
        @$('#report').append(view.render().el)
        @daysToDispatchReport()
    this

  daysToDispatchReport: ->
    @deliveries.fetch success: =>
      App.vent.trigger "loading:remove:success"
      dispatchs = @deliveries.pluckDistinct('dispatch')
      for dispatch in dispatchs
        @dels = @deliveries.where({dispatch: dispatch})
        for del, i in @dels
          dispatchRow = "<td rowspan='#{@dels.length}'>#{dispatch}</td>"
          guidesRow = "<td>#{del.guides()}</td>"
          arrivalRow = "<td>#{del.get('arrival_date')}</td>"
          deliveryRow = "<td>#{del.get('delivery_date')}</td>"
          daysToDispatchRow = "<td>#{del.daysToDispatch()}</td>"
          if i == 0
            @$('#deliveries').append("<tr>#{dispatchRow}#{guidesRow}#{arrivalRow}#{deliveryRow}#{daysToDispatchRow}</tr>")
          else
            @$('#deliveries').append("<tr>#{guidesRow}#{arrivalRow}#{deliveryRow}#{daysToDispatchRow}</tr>")
    this

  itemsStatusReport: ->
    if @$('#brand').val() == '' then brand = null else brand = @$('#brand').val()
    if @$('#season').val() == '' then season = null else season = @$('#season').val()
    if @$('#entry').val() == '' then entry = null else entry = @$('#entry').val()
    @collection.fetch success: =>
      if brand == null
        if season == null
          if entry == null
            return @appendItems(@collection)
          else
            array = @collection.where({entry: entry})
            return @appendItems(array, true)
        else
          if entry == null
            array = @collection.where({season: season})
            return @appendItems(array, true)
          else
            array = @collection.where({season: season ,entry: entry})
            return @appendItems(array, true)
      else
        if season == null
          if entry == null
            array = @collection.where({brand: brand})
            return @appendItems(array, true)
          else
            array = @collection.where({brand: brand, entry: entry})
            return @appendItems(array, true)
        else
          if entry == null
            array = @collection.where({brand: brand, season: season})
            return @appendItems(array, true)
          else
            array = @collection.where({brand: brand, season: season ,entry: entry})
            return @appendItems(array, true)
    this

  appendItems: (items, array = false) ->
    if items.length == 0
      @fh.displayFlash('info', "No se han encontrado resultados para su seleccion de filtros.", "20000")
      return App.vent.trigger "loading:remove:success"
    items.forEach (item) =>
      if array == false
        view = new App.Views.Item(model:item, collection: items)
      else
        view = new App.Views.Item(model:item)
        if App.colHelper.colHasDupes( _.map(items, (i) -> return i.get('code') )).indexOf(item.get('code')) > -1 then view.rowDangerClass()
      App.pushToAppendedViews(view)
      App.vent.trigger "loading:remove:success"
      @$('#items').append(view.render().el)
      view.removeHideButton()

  ################################################# $ Sort $ #############################################################
  removeChevron: ->
    @$("th i.icon-chevron-up").remove()
    @$("th i.icon-chevron-down").remove()
    @$("th i.icon-load").remove()

  sortItems: (e) ->
    @$('#fetch-items').html('  Actualizando').addClass('loading')
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar  =  @collection.sortVar
    @removeChevron()
    @$("th[data-sort=#{sortVar}]").append( '<i class="icon-load pull-right"></i>' )
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
    # @collection = @collection.page(page)
    # @collection.currentPage = page
    if type? and sortVar? and method?
      @collection.setSortVariables(type, sortVar, method)
    else
      @collection.setSortVariables(oldSortVarType, oldSortVar, oldSortMethod)
    App.vent.trigger 'update:items:success'
    # App.vent.trigger 'update:page', page
    @collection.sort()
    @appendItems(@collection)
    @$("th i.icon-load").remove()
#######################################################################################################################



