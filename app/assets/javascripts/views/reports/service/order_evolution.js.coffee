class App.Views.OrderEvolution extends Backbone.View
  template: JST['reports/service/order_evolution']

  className: 'span12'

  events:
    'click #show-chart'               : 'showChart'
    'click #hide-chart'               : 'hideChart'

  initialize: (options) ->
    @reportName = ''
    @fh = new App.Mixins.Form()
    @ch = new App.Mixins.ChartHelper()
    $(window).resize =>
      @drawCharts()
    if options?
      @from = options.from
      @to = options.to

  render: ->
    $(@el).html(@template(from: @from, to: @to))
    view  = new App.Views.Loading
    $(@el).append(view.render().el)
    @orderEvolution()
    this

  showChart: (e) ->
    e.preventDefault()
    @$('.chart-row').fadeIn('slow')
    @$('#show-chart').hide()
    @$('#hide-chart').show()
    @drawCharts()

  hideChart: (e) ->
    e.preventDefault()
    @$('.chart-row').fadeOut('slow')
    @$('#show-chart').show()
    @$('#hide-chart').hide()

  drawCharts: ->
    @totalsByCategory()
    @totalsByStatus()

  totalsByCategory: ->
    categorias = @collection.pluckDistinct("category1")
    @$('#categorias').empty()
    c = @ch.randomRGB()
    fillColor =  "rgba(#{c[0]},#{c[1]},#{c[2]},0.6)"
    strokeColor =  "rgba(#{c[0]},#{c[1]},#{c[2]},1)"
    datos =
      labels: []
      datasets: [
        fillColor     : fillColor
        strokeColor   : strokeColor
        data          : []
      ]
    for categoria in categorias
      datos.labels.push(categoria)
      datos.datasets[0].data.push(@data[categoria]["suma"])
      @$('#categorias').append("
            <tr>
              <td>#{categoria}</td>
              <td>#{@data[categoria]["suma"]}</td>
            </tr>
          ")
    ctx = @ch.setCtx('service_requests_chart', 0.6, this)
    chart = new Chart(ctx).Bar(datos)

  totalsByStatus: ->
    estados = ["Cerrado", "Abierto", "Pendiente", "Nuevo"]
    @$('#estados').empty()
    c = @ch.randomRGB()
    fillColor =  "rgba(#{c[0]},#{c[1]},#{c[2]},0.6)"
    strokeColor =  "rgba(#{c[0]},#{c[1]},#{c[2]},1)"
    datos =
      labels: []
      datasets: [
        fillColor     : fillColor
        strokeColor   : strokeColor
        data          : []
      ]
    for estado in estados
      datos.labels.push(estado)
      datos.datasets[0].data.push(@data[estado + 's'])
      @$('#estados').append("
                  <tr>
                    <td>#{estado}</td>
                    <td>#{@data[estado + 's']}</td>
                  </tr>
                ")
    ctx = @ch.setCtx('service_requests_chart_2', 0.6, this)
    chart = new Chart(ctx).Bar(datos)

  orderEvolution: ->
    @collection = new App.Collections.ServiceRequests()
    @collection.fetch data:{user_id: App.user.id, to: @to, from: @from, status: "all"}, success: =>
      App.vent.trigger "loading:remove:success"
      if @collection.length == 0
        return @fh.displayFlash('info', "No se han encontrado resultados para su seleccion de filtros.", "20000")
      @orderDetailByCategory()
      console.log @collection
    this

  getStatusWithDateLength: (array, estado, fecha) ->
    _.filter(array, (model) =>
      if fecha == ""
        return model.get('status') == estado
      else
        return (model.get('status') == estado and App.dh.dateSmallerThan(fecha, model.get('created_at')))
    ).length

  orderDetailByCategory: ->
    estados = ["Cerrado", "Abierto", "Pendiente", "Nuevo"]
    categorias = @collection.pluckDistinct("category1")
    @data =
      Cerrados: 0
      Abiertos: 0
      Pendientes: 0
      Nuevos: 0
    for categoria in categorias
      @data[categoria] = {}
      array = @collection.where({category1: categoria})
      @data[categoria]["suma"] = 0
      for estado in estados
        @data[categoria][estado] = @getStatusWithDateLength(array, estado, @from)
        @data[categoria]["suma"] = @data[categoria]["suma"] + @data[categoria][estado]
        @data[estado + 's'] += @data[categoria][estado]
      @$('#detail_by_category').append("
        <tr>
          <td style='background-color: #a9a9a9;'>#{categoria}</td>
          <td>#{@data[categoria]["Cerrado"]}</td>
          <td>#{@data[categoria]["Abierto"]}</td>
          <td>#{@data[categoria]["Pendiente"]}</td>
          <td>#{@data[categoria]["Nuevo"]}</td>
          <td style='background-color: #c2c2c2;'>#{@data[categoria]["suma"]}</td>
        </tr>
      ")
    @$('#detail_by_category').append("
      <tr>
        <td style='background-color: #000000; color: #ffffff;'>TOTAL</td>
        <td style='background-color: #4a4a4a; color: #ffffff;'>#{@data["Cerrados"]}</td>
        <td style='background-color: #4a4a4a; color: #ffffff;'>#{@data["Pendientes"]}</td>
        <td style='background-color: #4a4a4a; color: #ffffff;'>#{@data["Abiertos"]}</td>
        <td style='background-color: #4a4a4a; color: #ffffff;'>#{@data["Nuevos"]}</td>
        <td style='background-color: #000000; color: #ffffff;'>
          #{@data["Cerrados"] + @data["Abiertos"] + @data["Pendientes"] + @data["Nuevos"]}
        </td>
      </tr>
    ")

