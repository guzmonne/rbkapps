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
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
        App.vent.trigger 'changePassword:success'
      error: (user, status, response) ->
        alert "Los datos no coinciden. Verífique sus datos"
