class App.Views.ItemStatusComexReport extends Backbone.View
  itemsStatus: JST['reports/comex/items_status']

  className: 'span12'

  events:
    'click th'                        : 'sortItems'

  initialize: (options) ->
    @reportName = ''
    @fh = new App.Mixins.Form
    if options?
      @brand = options.brand
      @season = options.season
      @entry = options.entry

  render: ->
    $(@el).html(@itemsStatus())
    view  = new App.Views.Loading
    $(@el).append(view.render().el)
    @itemsStatusReport()
    this

  itemsStatusReport: (brand, season, entry) ->
    brand = @brand
    season = @season
    entry = @entry
    @collection = new App.Collections.Items()
    @collection.fetch success: =>
      if brand == null
        if season == null
          if entry == null
            return @appendItems(@collection)
          else
            array = @collection.where({entry: entry})
            return @callAppendItems(array)
        else
          if entry == null
            array = @collection.where({season: season})
            return @callAppendItems(array)
          else
            array = @collection.where({season: season ,entry: entry})
            return @callAppendItems(array)
      else
        if season == null
          if entry == null
            array = @collection.where({brand: brand})
            return @callAppendItems(array)
          else
            array = @collection.where({brand: brand, entry: entry})
            return @callAppendItems(array)
        else
          if entry == null
            array = @collection.where({brand: brand, season: season})
            return @callAppendItems(array)
          else
            array = @collection.where({brand: brand, season: season ,entry: entry})
            return @callAppendItems(array)
    this

  callAppendItems: (array) ->
    @collection = new App.Collections.Items()
    @collection.reset(array)
    return @appendItems(@collection)

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
    @update(type, sortVar, method)

  update: (type, sortVar, method) ->
    oldSortVarType      = @collection.sortVarType
    oldSortVar          = @collection.sortVar
    oldSortMethod       = @collection.sortMethod
    if @filtered == false then @collection = App.items
    if type? and sortVar? and method?
      @collection.setSortVariables(type, sortVar, method)
    else
      @collection.setSortVariables(oldSortVarType, oldSortVar, oldSortMethod)
    App.vent.trigger 'update:items:success'
    @collection.sort()
    @appendItems(@collection)
    @$("th i.icon-load").remove()
########################################################################################################################

