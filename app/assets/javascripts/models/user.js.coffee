class App.Models.User extends Backbone.Model
  urlRoot: '/api/users'

  url: ->
    u = '/api/users'
    if @id then u = u + "/#{@id}"
    return u

  defaults: ->
    id: null
    name: null
    email: null
    position: null
    phone: null
    cellphone: null
    location_id: null
    team_id: null
    remember_token: null
    admin: false

  isSupervisor: ->
    team = App.teams.get(@get("team_id"))
    if @id == team.get("supervisor_id") or @id == team.get("director_id")
      return true
    else
      return false

  admin: ->
    return @get('admin')

  maintenance: ->
    return @get('maintenance')

  changePasword: (credentials) ->
    attributes =
      user:
        password_confirmation: credentials.confirm_password
        password: credentials.password
    $.ajax
      url: "/api/users/#{@id}"
      data: attributes
      type: 'PUT'
      dataType: 'json'
      success: (data) =>
        $('#change-password-modal').modal('toggle')
        App.vent.trigger 'changePassword:success'
      error: (user, status, response) ->
        alert "Los datos no coinciden. Verífique sus datos"

  customSave: (attributes, options) ->
    $.ajax
      url: "/api/users"
      data: attributes
      type: 'POST'
      dataType: 'json'
      success: (data, status, response) ->
        options.success(data, status, response)
      error: (data, status, response) ->
        options.error(data, status, response)