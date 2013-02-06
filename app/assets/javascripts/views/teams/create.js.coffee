class App.Views.TeamCreate extends Backbone.View
  template: JST['teams/create']
  name: 'TeamCreate'
  className: 'span12'

  events:
    'click #submit-create-team': 'createTeam'
    'click #clear-form': 'cleanForm'

  initialize: ->
    @model = new App.Models.Team()
    @formHelper = new App.Mixins.Form()

  render: ->
    render: ->
    $(@el).html(@template(team: @model))
    this

  createTeam: (e) ->
    e.preventDefault()
    @formHelper.removeValidations()
    if $('#supervisor').val() == "Seleccionar Supervisor"
      $('#control-supervisor').addClass('error')
      return @formHelper.displayFlash('error', 'Seleccione un Supervisor')
    if $('#director').val() == "Seleccionar Director"
      $('#control-director').addClass('error')
      return @formHelper.displayFlash('error', 'Seleccione un Director')
    attributes =
      team:
        name: $('#name').val()
        supervisor_id: $('#supervisor').find('option:selected').data('id')
        director_id: $('#director').find('option:selected').data('id')
    @model.save(attributes, {success: @handleSuccess, error: @handleError})

  handleSuccess: (data, status, response) =>
    @formHelper.cleanForm('#create-team')
    @formHelper.displayFlash('success', 'El Equipo se ha creado con exito')
    @model.set(data)
    App.teams.add(@model)
    @model = new App.Models.Team()

  handleError: (data, status, response) =>
    @formHelper.displayFlash("error","Por favor verifique sus datos.")
    if data.status == 422
      errors = $.parseJSON(data.responseText).errors
      for attribute, messages of errors
        @formHelper.showInForm(attribute, message) for message in messages

  cleanForm: (e) ->
    e.preventDefault()
    @formHelper.cleanForm('#create-team')
    @formHelper.removeValidations()