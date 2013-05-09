class App.Views.NoteShow extends Backbone.View
  template: JST['notes/show']
  className: 'note-box'
  name: 'ShowNote'
########################################################################################################################

################################################### $ Initialize $ #####################################################
  initialize: ->
    @model.set('user', App.users.getNameFromId(@model.get('user_id')))
    if @model.get('updated_at')? then updatedAt = @model.get('updated_at').split('T') else updatedAt = null
    if updatedAt == null then date = Date.parse('today').toString('dd-MM-yyyy') else date = updatedAt[0]
    if updatedAt == null then time = Date.parse('now').toString('hh:mm') else time = updatedAt[1].split('-')[0]
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

################################################## $ Remove View $ #####################################################
  hideCloseButton: (e) ->
    @$('.close-note').hide()
    this
########################################################################################################################

################################################## $ Span8 $ ###########################################################
  sizeSpan8: (e) ->
    $(@el).addClass('span8')
    this
########################################################################################################################