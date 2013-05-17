class App.Views.DaysToDispatchComexReport extends Backbone.View
  itemsStatus: JST['reports/comex/days_to_dispatch']

  className: 'span12'

  #events:
  #  'click th'                        : 'sortItems'

  initialize: (options) ->
    @fh = new App.Mixins.Form
    @deliveries = new App.Collections.Deliveries

  render: ->
    $(@el).html(@itemsStatus())
    view  = new App.Views.Loading
    $(@el).append(view.render().el)
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
