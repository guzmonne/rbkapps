class App.Views.Loading extends Backbone.View
  template: JST['layout/loading']
  name: 'Loading'

  initialize: ->
    @listenTo App.vent, "loading:remove:success", -> @remove()

  render: ->
    $(@el).html(@template())
    this


