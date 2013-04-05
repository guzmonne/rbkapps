class App.Views.Team extends Backbone.View
  template: JST['teams/team']
  tagName: 'tr'
  name: 'Team'

  events:
    'click': 'showTeam'

  initialize: ->
    @model.set('supervisor', App.users.getNameFromId(@model.get('supervisor_id')))
    @model.set('director', App.users.getNameFromId(@model.get('director_id')))

  render: ->
    $(@el).html(@template(model: @model))
    this

  showTeam: ->
    view = new App.Views.ShowTeam(model: @model)
    Backbone.history.navigate "teams/show/#{@model.id}"
    App.setAndRenderContentViews([view])