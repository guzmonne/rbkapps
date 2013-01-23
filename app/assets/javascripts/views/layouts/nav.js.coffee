class App.Views.Nav extends Backbone.View
  template: JST['layout/nav']
  tagName: "nav"
  className: "navbar-inner"

  events:
    'click #nav-home': 'home'
    'click #sign-out':  'signOut'
    'click #nav-user': 'home'
    'click #nav-new-user': 'createUser'

  render: ->
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

