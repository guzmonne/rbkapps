class App.Views.UserEdit extends Backbone.View
  template: JST['users/edit']
  name: 'UserEdit'
  className: 'span12'
  #model = new App.Models.User()

  events:
    'click #submit-update-user' : 'createUser'
    'click #clear-form'         : 'cleanForm'

  initialize: ->
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(user: @model))
    for attribute of @model.attributes
      if @$('#' + attribute).attr('type') == 'checkbox'
        @$('#' + attribute).attr('checked', @model.get(attribute))
      else
        if attribute == 'team_id'
          @$('#team').val(App.teams.getNameFromId(@model.get('team_id')))
        else
          @$('#' + attribute).val(@model.get(attribute))
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
        location_id           : @$('#location_id').val()
        password              : @$('#password').val()
        password_confirmation : @$('#password_confirmation').val()
        admin                 : admin
        comex                 : comex
        compras               : compras
        director              : director
        maintenance           : maintenance
    @model.save attributes,
      success : @handleSuccess(attributes)
      error   : @handleError

  handleSuccess: (attributes) =>
    $("html, body").animate({ scrollTop: 0 }, "slow")
    @formHelper.displayFlash('success', 'Se han actualizado los datos con exito', 10000)
    @model.set(attributes)

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
