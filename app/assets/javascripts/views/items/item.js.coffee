class App.Views.Item extends Backbone.View
  template: JST['items/item']
  tagName: 'tr'
  name: 'Item'

  render: ->
    $(@el).html(@template(model: @model))
    this