window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Mixins: {}

  vent              : _.extend({}, Backbone.Events)
  users             : null
  teams             : null
  user              : null
  session           : null
  navView           : null
  purchaseRequests  : null
  purchaseOrders    : null
  items             : null
  deliveries        : null
  invoices          : null
  formHelpers       : null
  loading           : null
  started           : null
  d_i               : null
  suppliers         : null
  categories        : null
  fh                : null
  serviceRequests   : null
  contentViews      : []
  appendedViews     : []

  initialize: ->
    @navView          = new App.Views.Nav()
    @user             = new App.Models.User()
    @users            = new App.Collections.Users()
    @users.reset($('#user-container').data('users'))
    @teams            = new App.Collections.Teams()
    @teams.reset($('#team-container').data('teams'))
    @session          = new App.Models.Session()
    @purchaseRequests = new App.Collections.PurchaseRequests()
    @purchaseOrders   = new App.Collections.PurchaseOrders()
    @serviceRequests  = new App.Collections.ServiceRequests()
    @items            = new App.Collections.Items()
    @deliveries       = new App.Collections.Deliveries()
    @invoices         = new App.Collections.Invoices()
    @formHelpers      = new App.Collections.FormHelpers()
    @formHelpers.reset($('#form_helpers-container').data('form-helpers'))
    @d_i              = new App.Collections.DeliveriesItems()
    @suppliers        = new App.Collections.Suppliers()
    @suppliers.reset($('#suppliers-container').data('suppliers'))
    @categories       = new App.Collections.Categories()
    @colHelper        = new App.Mixins.Collections()
    @fh               = new App.Mixins.Form()
    @dh               = new App.Mixins.DateHelper()
    App.start()

  start: ->
    if @session.load().authenticated()
      $('body').css('background-color', 'white')
      @user.fetch
        data:
          remember_token: $.cookie('remember_token')
        success: =>
          @setNav()
          @complete()
    else
      @complete()
    this

  complete: ->
    if @started == true then return true
    new App.Routers.Nav()
    new App.Routers.User()
    new App.Routers.PurchaseRequest()
    new App.Routers.PurchaseOrder()
    new App.Routers.Teams()
    new App.Routers.Item()
    new App.Routers.Delivery()
    new App.Routers.Invoice()
    new App.Routers.Reports()
    new App.Routers.ServiceRequests()
    new App.Routers.Supplier()
    Backbone.history.start({pushState: true})
    @started = true

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
    if view?
      view.unbind()
      view.remove()
      view.model.off() unless view.model == undefined
      view.collection.off() unless view.collection == undefined
      App.vent.off(null, null, view)
      view.close() if view.hasOwnProperty('close')

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
    $('body').css('background-color', 'transparent')
    @user     = new App.Models.User
    @session  = new App.Models.Session
    @purchaseRequests = new App.Collections.PurchaseRequests()
    return @

$(document).ready ->
  App.initialize()


