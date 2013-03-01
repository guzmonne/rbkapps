window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Mixins: {}

  vent: _.extend({}, Backbone.Events)
  users: null
  teams: null
  user: null
  session: null
  navView: null
  purchaseRequests: null
  items: null
  deliveries: null
  invoices: null
  formHelpers: null
  contentViews: []
  appendedViews: []

  initialize: ->
    @navView          = new App.Views.Nav()
    @user             = new App.Models.User()
    @users            = new App.Collections.Users()
    @users.reset($('#user-container').data('users'))
    @teams            = new App.Collections.Teams()
    @teams.reset($('#team-container').data('teams'))
    @session          = new App.Models.Session()
    @purchaseRequests = new App.Collections.PurchaseRequests()
    @items            = new App.Collections.Items()
    @deliveries       = new App.Collections.Deliveries()
    @invoices         = new App.Collections.Invoices()
    @formHelpers      = new App.Collections.FormHelpers()
    @formHelpers.reset($('#form_helpers-container').data('form-helpers'))
    App.start()
    new App.Routers.Nav()
    new App.Routers.User()
    new App.Routers.PurchaseRequest()
    new App.Routers.Teams()
    new App.Routers.Item()
    new App.Routers.Delivery()
    new App.Routers.Invoice()
    Backbone.history.start({pushState: true})

  start: ->
    if @session.load().authenticated()
      @user = @users.get($.cookie('user_id')) if @user.get('id') == null
      @purchaseRequests.user_id = $.cookie('user_id')
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

  pushToAppendedViews: (view) ->
    @appendedViews.push view

  signOut: ->
    $.removeCookie('user_id')
    $.removeCookie('remember_token')
    @user = new App.Models.User
    @purchaseRequests = new App.Collections.PurchaseRequests()
    return @

$(document).ready ->
  App.initialize()


