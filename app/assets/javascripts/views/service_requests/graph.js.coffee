class App.Views.ServiceRequestGraph extends Backbone.View
  template: JST['service_request/graph']
  className: 'span6'
  name: 'ServiceRequestsGraph'

  initialize: ->
    @collection = App.serviceRequests
    @listenTo @collection, 'reset', => @renderGraph

  render: ->
    $(@el).html(@template())
    if @collection.length == 0
      App.serviceRequests.fetch()
    this

  renderGraph: ->
    console.log "I am going to be a graph!"