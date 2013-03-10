class App.Routers.User extends Backbone.Router

  routes:
    'home'        : 'show'
    'users/new'   : 'create'
    'users/index' : 'index'

  show: ->
    view = new App.Views.Loading()
    App.setAndRenderContentViews([view])
    if App.user.isNew()
      App.user.fetch success: =>
        team = App.teams.get(App.user.get('team_id'))
        App.user.set('team', team.name) if team?
        view = new App.Views.UserShow(model: App.user)
        App.setAndRenderContentViews([view])
        this
    else
      view = new App.Views.UserShow(model: App.user)
      App.setAndRenderContentViews([view])
      this

  create: ->
    view = new App.Views.UserCreate()
    App.setAndRenderContentViews([view])
    this

  index: ->
    view = new App.Views.UsersIndex(collection: App.teams)
    App.setAndRenderContentViews([view])
