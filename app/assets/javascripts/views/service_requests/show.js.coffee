class App.Views.ServiceRequestsShow extends Backbone.View
  template: JST['service_request/show']
  className: 'span12'
  name: 'ServiceRequestShow'
########################################################################################################################

############################################## $ Events $ ##############################################################
  events:
    'click #nav-prev-service-request' : 'nextServiceRequest'
    'click #nav-next-service-request' : 'prevServiceRequest'
    'click #add-note'                 : 'newNote'
    'click #save-service-request'     : 'saveServiceRequest'
    'click label[for="notes"]'        : 'toggleNotes'
    'click #edit-service-request'     : 'showAll'
    'click #clear-form'               : 'clearForm'
    'click #index-service-request'    : 'indexServiceRequest'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @notes = new App.Collections.Notes()
    @category = new App.Models.Category()
    @collectionHelper = new App.Mixins.Collections
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
      if attribute == 'status'
        @$('#label-status').text(@model.get(attribute))
        @colorStatusLabel()
      @$('#' + attribute).val(@model.get(attribute))
    @closeServiceRequest()
    this

  closeServiceRequest: ->
    unless App.user.admin() or App.user.maintenance()
      return @hideAll()
    if @model.status() == "Cerrado" or @model.status() == "Cerrado y Verificado"
      return @hideAll()

  hideAll: ->
    e.preventDefault() if e?
    @$('input').attr("disabled", true)
    @$('select').attr("disabled", true)
    @$('#solution').attr("disabled", true)
    @$('#save-service-request').hide()
    @$('#edit-service-request').show()
    @$('.form-actions').hide() unless App.user.admin() or App.user.maintenance()

  showAll: (e) ->
    e.preventDefault() if e?
    @$('input').attr("disabled", false)
    @$('select').attr("disabled", false)
    @$('#solution').attr("disabled", false)
    @$('#save-service-request').show()
    @$('#edit-service-request').hide()
    @$('.form-actions').show() if App.user.admin() or App.user.maintenance()

  colorStatusLabel: ->
    @$('#label-status').removeClass().addClass("label label-big pull-right")
    switch @model.status()
      when "Nuevo"
        @$('#label-status').addClass('label-info')
        break
      when "Abierto"
        @$('#label-status').addClass('label-warning')
        break
      when "Pendiente"
        @$('#label-status').addClass('label-important')
        break
      when "Cerrado"
        @$('#label-status').addClass('label-success')
        break

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
    if status == "Cerrado"
      closed_at = App.dh.now()
    else if status == "Cerrado y Verificado" and @model.get("closed_at") == null
      closed_at = App.dh.now()
    else
      closed_at == @model.get("closed_up")
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
      @$('#closed_at').val(@model.get('closed_at'))
      @$('#label-status').text(@model.status())
      @colorStatusLabel()
      @$('#save-service-request').attr('disabled', false)
      @$('#save-service-request').html('Guardar Cambios')
      @$('#notice').empty()
      App.fh.displayFlash("success", "Los cambios se han guardado con exito.", 3000)
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

###################################### $ Previous Purchase Request $ ###################################################
  prevServiceRequest: ->
    if App.serviceRequests.length == 0
      App.serviceRequests.fetch  data:{user_id: App.user.id}, success: @gotoPrevServiceRequest()
    else
      @gotoPrevServiceRequest()

  gotoPrevServiceRequest: ->
    index = @collectionHelper.getModelId(@model, App.serviceRequests)
    collectionSize = App.serviceRequests.length
    if index == 0
      App.vent.trigger "service_requests:show", App.serviceRequests.models[(collectionSize-1)]
    else
      App.vent.trigger "service_requests:show", App.serviceRequests.models[(index - 1)]
########################################################################################################################

######################################## $ Next Purchase Request $ #####################################################
  nextServiceRequest: ->
    if App.serviceRequests.length == 0
      App.serviceRequests.fetch  data:{user_id: App.user.id}, success: @gotoNextServiceRequest()
    else
      @gotoNextServiceRequest()

  gotoNextServiceRequest: ->
    index = @collectionHelper.getModelId(@model, App.serviceRequests)
    collectionSize = App.serviceRequests.length
    if index == collectionSize-1
      App.vent.trigger "service_requests:show", App.serviceRequests.models[0]
    else
      App.vent.trigger "service_requests:show", App.serviceRequests.models[(index + 1)]
########################################################################################################################

######################################## $ Service Request Index $ #####################################################
  indexServiceRequest: (e) ->
    e.preventDefault()
    Backbone.history.navigate "service_requests/index", trigger = true
    this
