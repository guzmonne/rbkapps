class App.Views.ServiceRequestsIndex extends Backbone.View
  template: JST['service_requests/index']
  className: 'span12'
  name: 'ServiceRequestsUsers'

  events:
    'click #fetch-service_requests'  : 'fetchServiceRequests'
    'click #new-service-request'     : 'newServiceRequest'

  render: ->
    $(@el).html(@template())
    this

  appendServiceRequest: (model) =>
    view = new App.Views.User(model: model)
    App.pushToAppendedViews(view)
    @$('#users').append(view.render().el)
    this

  fetchServiceRequests: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:service_requests'
    @$('#fetch-service_requests').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.users.fetch success: =>
      @$('#fetch-service_requests').html('Actualizar').removeClass('loading')
      App.users.each(@appendServiceRequest)
    this

  newServiceRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'service_requests/new', trigger = true
    this
