class App.Views.UserCreate extends Backbone.View
  template: JST['users/create']
  name: 'UserCreate'
  className: 'span12'

  events:
    'click #submit-create-user': 'createUser'
    'click #clear-form': 'cleanForm'

  initialize: ->
    @model = new App.Models.User()
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(user: @model))
    this

  createUser: (e) ->
    e.preventDefault()
    @formHelper.removeValidations()
    if @$('#admin').attr("checked") then admin = true else admin = false
    if @$('#comex').attr("checked") then comex = true else comex = false
    if @$('#compras').attr("checked") then compras = true else compras = false
    if @$('#director').attr("checked") then director = true else director = false
    if @$('#maintenance').attr("checked") then maintenance = true else maintenance = false
    attributes =
      user:
        name                  : @$('#name').val()
        email                 : @$('#email').val()
        phone                 : @$('#phone').val()
        cellphone             : @$('#cellphone').val()
        position              : @$('#position').val()
        team_id               : @$('#team').find('option:selected').data('id')
        location              : @$('#location').val()
        password              : @$('#password').val()
        password_confirmation : @$('#password_confirmation').val()
        admin                 : admin
        comex                 : comex
        compras               : compras
        director              : director
        maintenance           : maintenance
    @model.save attributes, success: @handleSuccess, error: @handleError

  handleSuccess: (data, status, response) =>
    @formHelper.cleanForm('#create-user')
    @formHelper.displayFlash('success', 'El Usuario se ha creado con exito', 10000)
    @model.set(data)
    App.users.add(@model)
    $("html, body").animate({ scrollTop: 0 }, "slow")

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
