class App.Views.Loading extends Backbone.View
  template: JST['layout/loading']
  name: 'Loading'

  render: ->
    $(@el).html(@template())
    this


