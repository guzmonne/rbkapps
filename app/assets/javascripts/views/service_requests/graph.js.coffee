class App.Views.ServiceRequestGraph extends Backbone.View
  activeRequestsByStatus: JST['service_request/_chart_active_request_by_status']
  activeRequestsByCategory: JST['service_request/_chart_active_request_by_category']
  className: 'span6'
  name: 'ServiceRequestsActiveRequestByStatusChart'

  events:
    'click .sync-chart'      : 'syncChart'

  initialize: ->
    @collection = App.serviceRequests
    @listenTo @collection, 'reset', =>
      @drawActiveRequestsByStatus()
      @drawActiveRequestsByCategory()
    @timer = 0

  render: ->
    $(@el).append(@activeRequestsByStatus())
    if @collection.length == 0
      App.serviceRequests.fetch data: {user_id: App.user.id}
    else
      @drawActiveRequestsByStatus()
    @timer = @startLoop()
    this

  render2: ->
    $(@el).append(@activeRequestsByCategory())
    @drawActiveRequestsByCategory()
    this

  close: ->
    clearInterval(@timer)

  syncChart: (e) ->
    e.preventDefault() if e?
    if e.currentTarget.dataset["chart"] == "active_request_by_status"
      App.serviceRequests.fetch data: {user_id: App.user.id}

  drawActiveRequestsByStatus: ->
    ctx = @$("#service_requests_chart")[0].getContext("2d")
    nuevo = App.serviceRequests.where({status: "Nuevo"}).length
    abierto = App.serviceRequests.where({status: "Abierto"}).length
    pendiente = App.serviceRequests.where({status: "Pendiente"}).length
    if nuevo > 0
      fillColor = "rgba(209, 0, 0, 0.5)"
      strokeColor = "rgba(209, 0, 0, 1)"
    else if nuevo == 0 and pendiente > 0
      fillColor = "rgba(220, 109, 0, 0.5)"
      strokeColor = "rgba(220, 109, 0, 1)"
    else
      fillColor = "rgba(0, 159, 188, 0.5)"
      strokeColor = "rgba(0, 159, 188, 1)"

    @data =
      labels: ["Nuevo", "Abierto", "Pendiente"]
      datasets: [
        fillColor     : fillColor
        strokeColor   : strokeColor
        data          : [nuevo, abierto, pendiente]
      ]
    chart = new Chart(ctx).Bar(@data)
    @$('.active_new').text(nuevo)
    @$('.active_open').text(abierto)
    @$('.active_pending').text(pendiente)

  rand: ->
    return Math.floor(Math.random()*256)

  drawActiveRequestsByCategoryBar: ->
    ctx = @$("#service_requests_chart_2")[0].getContext("2d")
    @$('#categories').empty()
    activeServices = _.filter App.serviceRequests.models, (model) =>
      status = model.get('status')
      if status == "Nuevo" or status == "Abierto" or status == "Pendiente"
        return model
    activeServicesCollection = new App.Collections.ServiceRequests()
    activeServicesCollection.reset(activeServices)
    console.log activeServicesCollection
    categories = activeServicesCollection.pluckDistinct('category1')
    console.log categories
    @values = []
    for category in categories
      len = activeServicesCollection.where({category1: category}).length
      @$('#categories').append("<tr><td>#{category}</td><td>#{len}</td></tr>")
      @values.push len
    c1 = @rand()
    c2 = @rand()
    c3 = @rand()
    @data =
      labels: categories
      datasets: [
        fillColor     : "rgba(#{c1},#{c2},#{c3},0.5)"
        strokeColor   : "rgba(#{c1},#{c2},#{c3},1)"
        data          : @values
      ]
    chart = new Chart(ctx).Bar(@data)

  drawActiveRequestsByCategory: ->
    ctx = @$("#service_requests_chart_2")[0].getContext("2d")
    @$('#categories').empty()
    activeServices = _.filter App.serviceRequests.models, (model) =>
      status = model.get('status')
      if status == "Nuevo" or status == "Abierto" or status == "Pendiente"
        return model
    activeServicesCollection = new App.Collections.ServiceRequests()
    activeServicesCollection.reset(activeServices)
    categories = activeServicesCollection.pluckDistinct('category1')
    @data = []
    @r = []
    @g = []
    @b = []
    for category in categories
      c = @goldenHSVtoRGB()
      @r.push c[0]; @g.push c[1]; @b.push c[2]
      c1 = @diffColor(c[0], @r, 0)
      c2 = @diffColor(c[1], @g, 1)
      c3 = @diffColor(c[2], @b, 2)
      len = activeServicesCollection.where({category1: category}).length
      @$('#categories').append("<tr><td style='color: #ffffff;background-color: rgba(#{c1},#{c2},#{c3},0.6);'>#{category}</td><td>#{len}</td></tr>")
      @data.push {value: len, color: "rgba(#{c1},#{c2},#{c3},0.6)"}
    chart = new Chart(ctx).Pie(@data,  { scaleShowValues: true, scaleFontColor : "#FFF" })

  startLoop: ->
    setInterval =>
      App.serviceRequests.fetch data: {user_id: App.user.id}
    , 30000

  diffColor: (c, colors, index) ->
    return c if colors.length == 1
    while (colors.indexOf(c) > -1 and c > 150 )
      c = @goldenHSVtoRGB()[index]
    return c

  hsvToRGB: (h, s, v) ->
    h_i = parseInt(h*6)
    f = h*6 - h_i
    p = v * (1 - s)
    q = v * (1 - f*s)
    t = v * (1 - (1 - f) * s )
    if h_i == 0
      r = v; g = t; b = p
    if h_i == 1
      r = q; g = p; b = v
    if h_i == 2
      r = p; g = v; b = t
    if h_i == 3
      r = p; g = q; b = v
    if h_i == 4
      r = t; g = p; b = v
    if h_i == 5
      r = v; g = p; b = q
    return [parseInt(r*256), parseInt(g*256), parseInt(b*256)]

  goldenHSVtoRGB: ->
    golden_ratio_conjugate = 0.618033988749895
    h = @alea()
    h += golden_ratio_conjugate
    h %= 1
    @hsvToRGB(h, 0.99, 0.99)

  alea: ->
    return Math.random()*256

