class App.Views.Delivery extends Backbone.View
  template: JST['deliveries/delivery']
  tagName: 'tr'
  name: 'Delivery'

  events:
    'dblclick'                : 'show'
    'click #remove-delivery'  : 'removeDelivery'

  initialize: ->
    @listenTo App.vent, 'update:deliveries:success', => @remove()

  render: ->
    $(@el).html(@template(model: @model))
    this

  show: ->
    Backbone.history.navigate("deliveries/show/#{@model.id}", true)
    this

  removeDelivery: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar este envío?")
    if result
      App.vent.trigger 'remove:delivery:success', @model
      @model.destroy()
      @remove()
