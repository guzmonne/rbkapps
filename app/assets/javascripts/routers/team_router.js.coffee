class App.Routers.Teams extends Backbone.Router

  routes:
    'teams/index': 'index'

  index: ->
    view = new App.Views.TeamsIndex(collection: App.teams)
    App.setAndRenderContentViews([view])