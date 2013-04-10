class App.Views.Supplier extends Backbone.View
  template: JST['suppliers/supplier']
  tagName: 'tr'
  name: 'Supplier'

  initialize: ->
    @listenTo App.vent, 'update:suppliers:success', => @remove()

  render: ->
    $(@el).html(@template(model: @model, dateHelper: @dateHelper))
    this