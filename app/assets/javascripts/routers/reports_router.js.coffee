class App.Routers.Reports extends Backbone.Router

  routes:
    'comex/reports'        : 'comexReports'

  comexReports: ->
    view = new App.Views.ComexReports
    App.setAndRenderContentViews([view])
    this

