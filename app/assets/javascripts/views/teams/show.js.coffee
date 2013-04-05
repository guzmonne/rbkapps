class App.Views.ShowTeam extends App.Views.TeamCreate
  template: JST['teams/show']
  name: 'TeamShow'
  className: 'span12'

  'events': _.extend({
    'click #update-team'      : 'updateTeam',
    }, App.Views.TeamCreate.prototype.events)

  initialize: ->
    @formHelper = new App.Mixins.Form()

  render: ->
    $(@el).html(@template(team: @model))
    @$('#supervisor').val(App.users.get(@model.get('supervisor_id')).get('name')) if @model.get('supervisor_id')?
    @$('#director').val(App.users.get(@model.get('director_id')).get('name')) if @model.get('director_id')?
    @$('#cost_center').val(@model.get('cost_center')) if @model.get('cost_center')?
    this

  updateTeam: (e) ->
    e.preventDefault()
    @model.set
        name          : @$('#name').val()
        supervisor_id : @$('#supervisor').find('option:selected').data('id')
        director_id   : @$('#director').find('option:selected').data('id')
        cost_center   : @$('#cost_center').val()
    @model.save(@model.attributes, success: => @formHelper.displayFlash("success", "El equipo se ha actualizado con exito", 2000))

