class App.Views.UserCreate extends Backbone.View
  template: JST['users/create']
  name: 'UserCreate'
  className: 'span12'
  model = new App.Models.User()

  events:
    'click #submit-create-user': 'createUser'
    'click #clear-form': 'cleanForm'

  initialize: ->
    @model = new App.Models.User()
    @formHelper = new App.Mixins.Form()

  render: ->
    render: ->
    $(@el).html(@template(user: @model))
    this

  createUser: (e) ->
    e.preventDefault()
    @formHelper.removeValidations()
    if $('#team').val() == "Seleccione un Equipo"
      $('#control-team_id').addClass('error')
      return @formHelper.displayFlash('error', 'Seleccione un equipo', 10000)
    attributes =
      user:
        name        : $('#name').val()
        email       : $('#email').val()
        phone       : $('#phone').val()
        cellphone   : $('#cellphone').val()
        position    : $('#position').val()
        team_id     : $('#team').find('option:selected').data('id')
        location_id : $('#location_id').val()
        password              : $('#password').val()
        password_confirmation : $('#password_confirmation').val()
        admin                : if $('#admin').attr("checked") then true else false
        comex                : if $('#admin').attr("checked") then true else false
    @model.save(attributes, {success: @handleSuccess, error: @handleError})

  handleSuccess: (data, status, response) =>
    @formHelper.cleanForm('#create-user')
    @formHelper.displayFlash('success', 'El Usuario se ha creado con exito')
    @model.set(data)
    console.log @model
    App.users.add(@model)

  handleError: (data, status, response) =>
    console.log $.parseJSON(data.responseText).errors, data, data.status
    @formHelper.displayFlash("error","Por favor verifique sus datos.")
    if data.status == 422
      errors = $.parseJSON(data.responseText).errors
      for attribute, messages of errors
        @formHelper.showInForm(attribute, message) for message in messages

  cleanForm: (e) ->
    e.preventDefault()
    @formHelper.cleanForm('#create-user')
    @formHelper.removeValidations()
