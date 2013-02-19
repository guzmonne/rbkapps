class App.Views.DeliveryIndex extends Backbone.View
  template: JST['deliveries/index']
  className: 'span12'
  name: 'IndexDelivery'

  render: ->
    $(@el).html(@template())
    App.deliveries.each(@appendDelivery)
    this

  appendDelivery: (model) =>
    model.set('item_code', App.items.get(model.get('item_id')).get('code') )
    view = new App.Views.Delivery(model: model)
    App.pushToAppendedViews(view)
    @$('#deliveries').append(view.render().el)
    this