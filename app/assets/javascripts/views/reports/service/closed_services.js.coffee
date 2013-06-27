class App.Views.ClosedServices extends Backbone.View
  template: JST['reports/service/closedservices']

  className: 'span12'

  events:
    'click #show-chart'               : 'showChart'
    'click #hide-chart'               : 'hideChart'

  initialize: (options) ->
    @reportName = ''
    @fh = new App.Mixins.Form()
    @ch = new App.Mixins.ChartHelper()
    $(window).on "resize", =>
      @drawCharts()
    if options?
      @from = options.from
      @to = options.to

  render: ->
    $(@el).html(@template())
    view  = new App.Views.Loading
    $(@el).append(view.render().el)
    @closedServices()
    this

  remove: ->
    $(window).off "resize"
    super()

  showChart: (e) ->
    e.preventDefault()
    @$('.chart-row').removeClass('hide')
    @$('#show-chart').addClass('hide')
    @$('#hide-chart').removeClass('hide')
    @drawCharts()

  hideChart: (e) ->
    e.preventDefault()
    @$('.chart-row').addClass('hide')
    @$('#show-chart').removeClass('hide')
    @$('#hide-chart').addClass('hide')

  drawCharts: ->
    @closedCategories()
    @closedLocations()
    @creationDates()
    @closedDates()

  creationDates: ->
    @$('#creation_dates').empty()
    creation_dates = []
    for model in @collection.models
      created_at = model.get('created_at').split('T')[0]
      creation_dates.push(created_at) unless creation_dates.indexOf(created_at) > -1
    creation_dates.sort()
    @data = {
      labels: creation_dates
      datasets: [{
        fillColor : "rgba(220,220,220,0.5)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : []
      }]
    }
    for date in creation_dates
      len = _.filter( @collection.models, (model) -> return ! model.get('created_at').indexOf(date) ).length
      @data.datasets[0].data.push(len)
      @$('#creation_dates').append("
                    <tr>
                      <td style='background-color: rgba(220,220,220,0.5);min-width: 80px;'>
                        #{date}
                      </td>
                      <td>#{len}</td>
                    </tr>")
    ctx = @ch.setCtx('service_requests_chart_2', 0.6, this)
    new Chart(ctx).Line(@data);

  closedDates: ->
    @$('#closed_dates').empty()
    closed_dates = @collection.pluckDistinct('closed_at').sort()
    @data = {
      labels: closed_dates
      datasets: [{
        fillColor : "rgba(230,230,230,0.5)",
        strokeColor : "rgba(230,230,230,1)",
        pointColor : "rgba(230,230,230,1)",
        pointStrokeColor : "#fff",
        data : []
      }]
    }
    for date in closed_dates
      len = _.filter( @collection.models, (model) -> return ! model.get('closed_at').indexOf(date) ).length
      @data.datasets[0].data.push(len)
      @$('#closed_dates').append("
                          <tr>
                            <td style='background-color: rgba(220,220,220,0.5);min-width: 80px;'>
                              #{date}
                            </td>
                            <td>#{len}</td>
                          </tr>")
    ctx = @ch.setCtx('service_requests_chart_4', 0.6, this)
    new Chart(ctx).Line(@data);

  closedCategories: ->
    @$('#categorias').empty()
    @categories = []
    @data = []
    for cat in @collection.pluckDistinct('category1')
      len = parseFloat(((@collection.where({category1: cat}).length / @collection.length)*100).toFixed(2))
      @categories.push([cat, len])
    @categories.sort((a,b) -> return b[1] - a[1])
    for cat in @categories
      c = @ch.randomRGB()
      c1 = c[0]; c2 = c[1]; c3 = c[2]
      @$('#categorias').append("
              <tr>
                <td style='color: #ffffff;background-color: rgba(#{c1},#{c2},#{c3},0.6);'>
                  #{cat[0]}
                </td>
                <td>#{cat[1]}% </td>
              </tr>")
      @data.push {value: cat[1], color: "rgba(#{c1},#{c2},#{c3},0.6)"}
    ctx = @ch.setCtx('service_requests_chart', 1, this)
    chart = new Chart(ctx).Pie(@data,  { scaleShowValues: true, scaleFontColor : "#FFF" })

  closedLocations: ->
    @$('#locations').empty()
    @locations = []
    @data = []
    for loc in @collection.pluckDistinct('location')
      len = parseFloat(((@collection.where({location: loc}).length / @collection.length)*100).toFixed(2))
      @locations.push([loc, len])
    @locations.sort((a,b) -> return b[1] - a[1])
    for loc in @locations
      c = @ch.randomRGB()
      c1 = c[0]; c2 = c[1]; c3 = c[2]
      @$('#locations').append("
                    <tr>
                      <td style='color: #ffffff;background-color: rgba(#{c1},#{c2},#{c3},0.6);'>
                        #{loc[0]}
                      </td>
                      <td>#{loc[1]}%</td>
                    </tr>")
      @data.push {value: loc[1], color: "rgba(#{c1},#{c2},#{c3},0.6)"}
    ctx = @ch.setCtx('service_requests_chart_3', 1, this)
    chart = new Chart(ctx).Pie(@data,  { scaleShowValues: true, scaleFontColor : "#FFF" })

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
    @$('#service_requests').append(view.render2().el)
    this