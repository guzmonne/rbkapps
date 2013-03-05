class App.Views.DeliveryIndex extends Backbone.View
  template: JST['deliveries/index']
  className: 'span12'
  name: 'IndexDelivery'

  initialize: ->

  events:
    'click #new-delivery'     : 'newDelivery'
    'click #fetch-deliveries' : 'fetchDeliveries'

  render: ->
    $(@el).html(@template())
    App.deliveries.each(@appendDelivery)
    this

  appendDelivery: (model) =>
    view = new App.Views.Delivery(model: model)
    App.pushToAppendedViews(view)
    @$('#deliveries').append(view.render().el)
    this

  newDelivery: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'deliveries/new', trigger: true
    this

  fetchDeliveries: (e) ->
    e.preventDefault()
    @$('#fetch-deliveries').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.deliveries.fetch success: =>
      @$('#fetch-deliveries').html('Actualizar').removeClass('loading')
      App.deliveries.each(@appendDelivery)
    this
