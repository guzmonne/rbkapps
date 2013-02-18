class App.Views.DeliveryShow extends Backbone.View
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  render: ->
    $(@el).html(@template())
    this