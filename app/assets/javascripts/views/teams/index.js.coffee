class App.Views.TeamsIndex extends Backbone.View
  template: JST['teams/index']
  className: 'span12'
  name: 'IndexTeams'

  render: ->
    $(@el).html(@template())
    App.teams.each(@appendTeam)
    this

  appendTeam: (model) =>
    console.log model
    view = new App.Views.Team(model: model)
    App.pushToAppendedViews(view)
    @$('#teams').append(view.render().el)
    this