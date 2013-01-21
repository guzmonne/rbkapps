class App.Models.Session extends Backbone.Model
  defaults: ->
    remember_token: null
    user_id: null

  initialize: ->
    @load()

  authenticated: ->
    Boolean(@get("remember_token"))

  save: (auth_hash) ->
    $.cookie('user_id', auth_hash.id)
    $.cookie('remember_token', auth_hash.remember_token)

  load: ->
    @set
      user_id: $.cookie('user_id')
      remember_token: $.cookie('remember_token')

