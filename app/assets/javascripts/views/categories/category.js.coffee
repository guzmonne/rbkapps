class App.Views.Category extends Backbone.View
  template: JST['categories/category']
  #tagName: 'tr'
  name: 'Category'

  initialize: ->
    @listenTo App.vent, 'update:categories:success', => @remove

  render: ->
    $(@el).html(@template(collection: @collection))
    this