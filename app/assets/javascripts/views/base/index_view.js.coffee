class App.Views.IndexView extends Backbone.View

  searchCollection: new App.Collections.Deliveries

  events:
    'click th'                : 'sortDeliveries'

  sortDeliveries: (e) ->
    sortVar =  e.currentTarget.dataset['sort']
    type    =  e.currentTarget.dataset['sort_type']
    oldVar  = @collection.sortVar
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
    App.vent.trigger 'update:deliveries:success'
    @collection.each(@appendDelivery)