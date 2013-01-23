class App.Routers.Nav extends Backbone.Router
  routes:
    'sign_in': 'signIn'

  signIn: ->
    view = new App.Views.SessionCreate()
    App.closeView(App.navView) unless App.navView == null
    App.setAndRenderContentViews([view], true)
    this