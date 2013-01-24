window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Mixins: {}

  vent: null
  users: null
  user: null
  session: null
  navView: null
  contentViews: []
  appendedViews: []

  initialize: ->
    @vent = _.extend({}, Backbone.Events)
    @navView = new App.Views.Nav()
    @user = new App.Models.User()
    @users = new App.Collections.Users()
    @users.reset($('#user-container').data('users'))
    @session = new App.Models.Session()
    App.start()
    new App.Routers.Nav()
    new App.Routers.User()
    Backbone.history.start({pushState: true})

  start: ->
    if @session.load().authenticated()
      @user = @users.get($.cookie('user_id')) if @user.get('id') == null
      @setNav()
    this

  setNav: ->
    @navView = new App.Views.Nav(model: @user)
    $('#nav-layout').html(@navView.render().el)
    this

  setContentViews: (views) ->
    @closeViews() unless @contentViews == []
    @closeAppendedViews() unless @appendedViews == []
    for view in views
      @contentViews.push view
    return @contentViews

  closeViews: ->
    for oldView in @contentViews
      @closeView(oldView)
    @contentViews = []

  closeAppendedViews: ->
    for oldView in @appendedViews
      @closeView(oldView)
    @appendedViews = []

  closeView: (view) =>
    view.unbind()
    view.remove()

  renderContentView: (view) =>
    $('#content-layout').append(view.render().el)

  renderContentViews: (renderViews) ->
    for view in renderViews
      @renderContentView(view)
    return 1

  setAndRenderContentViews: (views, everybody = false) ->
    unless everybody == true
      return Backbone.history.navigate('sign_in', trigger: true) unless @session.load().authenticated()
    renderViews = @setContentViews(views)
    @renderContentViews(renderViews)

  signOut: ->
    $.removeCookie('remember_token')
    $.removeCookie('user_id')
    @start()
    this

  pushToAppendedViews: (view) ->
    @appendedViews.push view

$(document).ready ->
  App.initialize()


