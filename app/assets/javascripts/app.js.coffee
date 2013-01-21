window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  vent: _.extend({}, Backbone.Events)
  user: null
  contentViews: []
  appendedViews: []

  initialize: ->
    new App.Routers.Nav

    @user = new App.Models.User()

    Backbone.history.start(pushState: true)

  start: ->
    @session = new App.Models.Session()
    if @session.load().authenticated()
      @user.set('id', $.cookie('user_id')).fetch({success: => @setNav()})
    else
      view = new App.Views.SessionCreate(model: @session)
      $('#content-layout').html(view.render().el)

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
      closeView(oldView)
    @contentViews = []

  closeAppendedViews: ->
    for oldView in @appendedViews
      closeView(oldView)
    @appendedViews = []

  closeView: (view) ->
    view.unbind()
    view.remove()

  renderContentView: (view) ->
    $('#content').append(view.render().el)

  renderContentViews: (renderViews) ->
    for view in renderViews
      @renderContentView(view)

  setAndRenderContentViews: (views, everybody = false) ->
    @start()
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
  App.start()

