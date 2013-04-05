class App.Routers.Teams extends Backbone.Router

  routes:
    'teams/index'     : 'index'
    'teams/new'       : 'create'
    'teams/show/:id'  : 'show'

  index: ->
    view = new App.Views.TeamsIndex(collection: App.teams)
    App.setAndRenderContentViews([view])

  create: ->
    view = new App.Views.TeamCreate()
    App.setAndRenderContentViews([view])

  show: (id) ->
    view = new App.Views.ShowTeam(model: App.teams.get(id))
    App.setAndRenderContentViews([view])