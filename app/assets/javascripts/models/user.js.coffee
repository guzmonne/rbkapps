class App.Models.User extends Backbone.Model
  url: ->
    "api/users/#{@id}"

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

  save: (attributes, options) ->
    $.ajax
      url: "/api/users"
      data: attributes
      type: 'POST'
      dataType: 'json'
      success: (data, status, response) ->
        options.success(data, status, response)
      error: (data, status, response) ->
        options.error(data, status, response)