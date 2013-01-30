class App.Views.Team extends Backbone.View
  template: JST['teams/team']
  tagName: 'tr'
  name: 'Team'

  events:
    'click': 'show'

  initialize: ->
    @dateHelper = new App.Mixins.Date

  render: ->
    $(@el).html(@template(model: @model))
    this

  show: ->
    Backbone.history.navigate("teams/show/#{@model.id}", true)
    this