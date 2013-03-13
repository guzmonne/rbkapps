class App.Views.ServiceRequestsCreate extends Backbone.View
  template: JST['service_request/create']
  className: 'span12'
  name: 'ServiceRequestIndex'

  initialize: ->

  render: ->
    $(@el).html(@template())
    this