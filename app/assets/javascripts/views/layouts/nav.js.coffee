class App.Views.Nav extends Backbone.View
  template: JST['layout/nav']
  tagName: "nav"
  className: "navbar-inner"

  events:
    'click #nav-home': 'home'
    'click #sign-out':  'signOut'
    'click #nav-user': 'home'
    'click #nav-new-user': 'createUser'
    'click #nav-purchase-request': 'createPurchaseRequest'
    'click #nav-index-purchase-request': 'indexPurchaseRequest'

  render: ->
    if @model.get('admin') ==  true
      $(@el).html(@template(user: @model)).find('.admin-only').removeClass('hide')
    else
      $(@el).html(@template(user: @model))
    this

  home: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'home', true
    this

  signOut: (e) ->
    e.preventDefault()
    $.removeCookie('user_id')
    $.removeCookie('remember_token')
    Backbone.history.navigate 'sign_in', trigger:true
    this

  createUser: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'users/new', trigger:true
    this

  createPurchaseRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_request/new', trigger: true
    this

  indexPurchaseRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'purchase_request/index', trigger: true
    this