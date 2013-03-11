class App.Views.ItemIndex extends Backbone.View
  template: JST['items/index']
  className: 'span12'
  name: 'IndexItem'

  initialize: ->
    @collection = App.items

  events:
    'click #new-item'         : 'newItem'
    'click #fetch-items'      : 'fetchItems'
    'click th'                : 'sortItems'

  render: ->
    $(@el).html(@template())
    App.items.each(@appendItem)
    this

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
      App.items.each(@appendItem)
    this

  sortItems: (e) ->
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
    App.vent.trigger 'update:items:success'
    @collection.each(@appendItem)