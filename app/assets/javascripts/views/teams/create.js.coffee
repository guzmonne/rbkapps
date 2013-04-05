class App.Views.TeamCreate extends Backbone.View
  template: JST['teams/create']
  name: 'TeamCreate'
  className: 'span12'

  events:
    'submit #create-team'             : 'createTeam'
    'click #submit-create-team'       : 'createTeam'
    'click #clear-form'               : 'cleanForm'
    'click #create-new-cost_center'   : 'createCostCenter'
    'click #cancel-cost_center'       : 'createCostCenter'
    'click #save-cost_center'         : 'saveCostCenter'

  initialize: ->
    @model = new App.Models.Team()
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(team: @model))
    this

  createCostCenter: (e) ->
    e.preventDefault() if e?
    @$('.create-cost_center').toggle()
    @$('#new-cost_center').focus()
    @$('#cost_center').focus()

  saveCostCenter: (e) ->
    e.preventDefault()
    model = new App.Models.FormHelper()
    attributes =
      column  : 'cost_center'
      value   : @$('#new-cost_center').val()
    model.save attributes, success: =>
      @formHelper.displayFlash('info', 'El Centro de Costos se ha creado con exito', 1000)
      App.formHelpers.add(model)
      @createCostCenter()
      @$('#cost_center').append("<option>#{model.get('value')}</option>").val(model.get('value'))
      @$('#new-cost_center').val('')
    this

  createTeam: (e) ->
    e.preventDefault()
    @formHelper.removeValidations()
    attributes =
      team:
        name: $('#name').val()
        supervisor_id : @$('#supervisor').find('option:selected').data('id')
        director_id   : @$('#director').find('option:selected').data('id')
        cost_center   : @$('#cost_center').val()
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