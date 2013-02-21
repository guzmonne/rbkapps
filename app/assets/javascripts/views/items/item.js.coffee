class App.Views.Item extends Backbone.View
  template: JST['items/item']
  tagName: 'tr'
  name: 'Item'

  events:
    'click #remove-item': 'removeItem'

  render: ->
    $(@el).html(@template(model: @model))
    this

  removeItem: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar este artículo")
    if result
      @remove()
      App.vent.trigger 'removeItem:success', @model