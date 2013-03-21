class App.Views.Delivery extends Backbone.View
  template: JST['deliveries/delivery']
  tagName: 'tr'
  name: 'Delivery'

  events:
    'click': 'show'

  initialize: ->
    @listenTo App.vent, 'update:deliveries:success', => @remove()

  render: ->
    $(@el).html(@template(model: @model))
    this

  show: ->
    Backbone.history.navigate("deliveries/show/#{@model.id}", true)
    this