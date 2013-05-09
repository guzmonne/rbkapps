class App.Views.ServiceRequestsCreate extends Backbone.View
  template: JST['service_request/create']
  className: 'span12'
  name: 'ServiceRequestIndex'
########################################################################################################################

############################################## $ Events $ ##############################################################
  events:
    'click #add-note'                 : 'newNote'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
########################################################################################################################

############################################## $ Render $ ##############################################################
  render: ->
    $(@el).html(@template())
    #@$('select').select2({width: 'copy'})
    @$('#location').val(App.user.get('location'))
    @$('#team').val(App.teams.get(App.user.get('team_id')).get('name') if App.user.get('team_id')?)
    this
########################################################################################################################

############################################## $ New Note $ ############################################################
  newNote: (e) ->
    e.preventDefault() if e?
    newNote = @$('#new-note').val()
    if newNote == "" then return @
    @$('#new-note').val('')
    model = new App.Models.Note
    attributes =
      note:
        content       : newNote
        user_id       : App.user.id
        table_name    : 'service_request'
        table_name_id : null
    #model.save attributes, success: =>
    model.set(attributes.note)
    view = new App.Views.NoteShow(model: model)
    App.pushToAppendedViews(view)
    @$('#notes').append(view.render().el)
    #view.sizeSpan8()
    this
########################################################################################################################

