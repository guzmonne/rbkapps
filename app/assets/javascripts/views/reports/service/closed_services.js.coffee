class App.Views.ClosedServices extends Backbone.View
  template: JST['reports/service/closedservices']

  className: 'span12'

  events:
    'click th'                        : 'sortItems'

  initialize: (options) ->
    @reportName = ''
    @fh = new App.Mixins.Form
    if options?
      @from = options.from
      @to = options.to
      console.log @to, @from

  render: ->
    $(@el).html(@template())
    view  = new App.Views.Loading
    $(@el).append(view.render().el)
    @closedServices()
    this

  closedServices: ->
    @collection = new App.Collections.ServiceRequests()
    @collection.fetch data:{user_id: App.user.id, to: @to, from: @from}, success: =>
      if @collection.length == 0
        App.vent.trigger "loading:remove:success"
        return @fh.displayFlash('info', "No se han encontrado resultados para su seleccion de filtros.", "20000")
      @collection.each @appendServices
    this

  appendServices: (model) ->
    view = new App.Views.ServiceRequest(model: model)
    App.pushToAppendedViews(view)
    App.vent.trigger "loading:remove:success"
    @$('#service_requests').append(view.render().el)
    this
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

