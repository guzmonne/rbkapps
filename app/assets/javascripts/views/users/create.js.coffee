class App.Views.UserCreate extends Backbone.View
  template: JST['users/create']
  name: 'UserCreate'
  className: 'span12'
  model = new App.Models.User()

  events:
    'click #submit-create-user': 'createUser'

  initialize: ->
    @model = new App.Models.User()
    @formHelper = new App.Mixins.Form()

  render: ->
    render: ->
    $(@el).html(@template(user: @model))
    this

  createUser: (e) ->
    e.preventDefault()
    attributes =
      user:
        name: $('#name').val()
        email: $('#email').val()
        phone: $('#phone').val()
        cellphone: $('#cellphone').val()
        position: $('#position').val()
        team_id: $('#team_id').val()
        location_id: $('#location_id').val()
        password: $('#password').val()
        password_confirmation: $('#password_confirmation').val()
        admin: $('#admin').val()
    @model.save(attributes, {success: @handleSuccess, error: @handleError})

  handleSuccess: =>
    @formHelper.cleanForm('#create-user')
    @formHelper.displayFlash('success', 'El Usuario se ha creado con exito')
    App.users.add(@model, {silent: true})

  handleError: (client, response) =>
    @formHelper.displayFlash("error","Por favor verifique sus datos.")
    if response.status == 422
      errors = $.parseJSON(response.responseText).errors
      for attribute, messages of errors
        @formHelper.showInForm(attribute,message) for message in messages




