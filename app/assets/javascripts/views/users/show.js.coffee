class App.Views.UserShow extends Backbone.View
  template: JST['users/show']
  name: 'UserShow'
  className: 'span12'

  events:
    'click #update-password': 'changePassword'
    'click #submit-change-password': 'submitChangePassword'

  render: ->
    $(@el).html(@template(user: @model))
    this

  changePassword: (e) ->
    e.preventDefault()
    $('#change-password-modal').modal('toggle')
    this

  submitChangePassword: (e) =>
    e.preventDefault()
    credentials =
      password: $('#password').val()
      confirm_password: $('#confirm-password').val()
    @model.changePasword(credentials)