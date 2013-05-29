class App.Views.ServiceRequestsShow extends Backbone.View
  template: JST['service_request/show']
  className: 'span12'
  name: 'ServiceRequestShow'
########################################################################################################################

############################################## $ Events $ ##############################################################
  events:
    'click #add-note'                 : 'newNote'
    'click #save-service-request'     : 'saveServiceRequest'
    'click label[for="notes"]'        : 'toggleNotes'
    'click #edit-service-request'     : 'showParameters'
    'click #clear-form'               : 'clearForm'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @notes = new App.Collections.Notes()
    @category = new App.Models.Category()
    @listenTo @notes, 'reset', => @setNotes()
    @listenTo @category, 'change', => @setCategory()
########################################################################################################################

############################################## $ Render $ ##############################################################
  render: ->
    $(@el).html(@template(model: @model))
    @notes.fetch(data:{table_name: 'service_request', table_name_id: @model.id})
    for attribute of @model.attributes
      if attribute == 'creator_id'
        attribute = 'team'
        user = App.users.get(@model.get('creator_id'))
        @model.set('team', App.teams.getNameFromId(user.get('team_id')))
        @$('#' + attribute).val(@model.get(attribute))
        attribute = 'created_by'
        @model.set('created_by', App.users.getNameFromId(@model.get('creator_id')))
      if attribute == 'category_id'
        @category.id = @model.get('category_id')
        @category.fetch()
      @$('#' + attribute).val(@model.get(attribute))
    @closeServiceRequest()
    this

  clearForm: (e) ->
    e.preventDefault()
    $(@el).empty()
    @render()
    this
########################################################################################################################

######################################## $ Submit Service Request $ ####################################################
  saveServiceRequest: (e) ->
    e.preventDefault() if e?
    #return if @validate()
    App.fh.displayFlash("info", "Espere por favor...", 2000)
    @$('#save-service-request').attr('disabled', true)
    @$('#save-service-request').html('<i class="icon-load"></i>  Espere por favor...')
    status = @$('#status').val()
    if status == "Cerrado" then closed_at = App.dh.now() else closed_at = null
    if @model.get('status') != "Cerrado" and @$('#status').val() == "Cerrado y Verificado"
      closed_at = App.dh.now()
    attributes =
      service_request:
        closed_at       : closed_at
        status          : @$('#status').val()
        priority        : @$('#priority').val()
        solution        : @$('#solution').val()
        modified_by     : App.user.id
    @model.save attributes, success: =>
      $("html, body").animate({ scrollTop: 0 }, "fast")
      @model.set(attributes.service_request)
      @closeServiceRequest()
      @$('#save-service-request').attr('disabled', false)
      @$('#save-service-request').html('Guardar Cambios')
      @$('#notice').empty()
      App.fh.displayFlash("success", "Los cambios se han guardado con exito.", 3000)

  closeServiceRequest: ->
    if @model.get('closed_at') == null
      @showParameters()
    else
      @hideParameters()

  showParameters: (e) ->
    e.preventDefault() if e?
    @$('.closed_at').hide()
    @$('#closed_at').val('')
    @$('.service_request').attr("disabled", false)
    @$('#save-service-request').show()

  hideParameters: (e) ->
    e.preventDefault() if e?
    @$('.closed_at').show()
    @$('#closed_at').val('').val(@model.get('closed_at'))
    @$('.service_request').attr("disabled", true)
    @$('#save-service-request').hide()
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
        table_name_id : @model.id
    model.save attributes, success: =>
      model.set(attributes.note)
      view = new App.Views.NoteShow(model: model)
      App.pushToAppendedViews(view)
      @$('#notes').append(view.render().el)
    this
########################################################################################################################

################################################# $ Set Events $ #######################################################
  setNotes: ->
    for note in @notes.models
      view = new App.Views.NoteShow(model: note)
      App.pushToAppendedViews(view)
      @$('#notes').append(view.render().el)
    @$('.close-note').remove()
    this

  setCategory: ->
    @$('#category1').val(@category.get('category1'))
    @$('#category2').val(@category.get('category2')) unless @category.get('category2') == 'SSC'
    @$('#category3').val(@category.get('category3')) unless @category.get('category3') == 'STC'
    this
########################################################################################################################

################################################# $ Set Events $ #######################################################
  toggleNotes: ->
    @$('#notes').slideToggle('slow')
    @$('.toggle_note').slideToggle('slow')
    @$('label[for="notes"]').toggleClass('filtered_label')
    if @$('label[for="notes"]').hasClass('filtered_label')
      @$('label[for="notes"]').html('Notas <i class="icon-filter"></i>')
    else
      @$('label[for="notes"]').html('Notas')
    this
########################################################################################################################