class App.Views.Item extends Backbone.View
  template: JST['items/item']
  tagName: 'tr'
  name: 'Item'

  initialize: ->
    @listenTo App.vent, 'delivery:create:success', => @remove()
    @listenTo App.vent, 'remove:items', => @remove()

  events:
    'click #remove-item': 'removeItem'

  render: ->
    $(@el).html(@template(model: @model))
    this

  removeItem: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar este artículo")
    if result
      App.vent.trigger 'remove:item:success', @model
      @remove()
