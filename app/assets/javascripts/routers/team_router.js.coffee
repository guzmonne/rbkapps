class App.Routers.Teams extends Backbone.Router

  routes:
    'teams/index': 'index'
    'teams/new': 'create'

  index: ->
    view = new App.Views.TeamsIndex(collection: App.teams)
    App.setAndRenderContentViews([view])

  create: ->
    view = new App.Views.TeamCreate()
    App.setAndRenderContentViews([view])