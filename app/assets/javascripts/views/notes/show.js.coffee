class App.Views.NoteShow extends Backbone.View
  template: JST['notes/show']
  className: 'note-box'
  name: 'ShowNote'
########################################################################################################################

################################################### $ Initialize $ #####################################################
  initialize: ->
    @model.set('user', App.users.getNameFromId(@model.get('user_id')))
    updatedAt = @model.get('updated_at').split('T')
    date = updatedAt[0]
    time = updatedAt[1].split('-')[0]
    @model.set('date', date)
    @model.set('time', time)
    #@listenTo App.vent, "note:show:block", => @blockView()
    #@listenTo App.vent, "note:show:unblock", => @unblockView()
########################################################################################################################

##################################################### $ Events $ #######################################################
  events:
    'click .close-note'        : 'removeNote'
########################################################################################################################

##################################################### $ Render $ #######################################################
  render: ->
    $(@el).html(@template(model: @model))
    this
########################################################################################################################

################################################## $ Remove View $ #####################################################
  removeNote: (e) ->
    e.preventDefault() if e?
    result = confirm("Esta seguro que desea eliminar esta nota?")
    if result
      @model.destroy()
      @remove()
########################################################################################################################