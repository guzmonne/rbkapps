class App.Views.ServiceRequestsCreate extends Backbone.View
  template: JST['service_request/create']
  className: 'span12'
  name: 'ServiceRequestCreate'
########################################################################################################################

############################################## $ Events $ ##############################################################
  events:
    'click #add-note'                 : 'newNote'
    'change #category'                : 'changeSubCategories'
    'change #category2'               : 'changeThirdCategories'
    'click #submit-service-request'   : 'submitServiceRequest'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @notes = new App.Collections.Notes()
    @model = new App.Models.ServiceRequest()
    @listenTo App.categories, 'reset', =>
      @setCategories()
########################################################################################################################

############################################## $ Render $ ##############################################################
  render: ->
    $(@el).html(@template())
    App.categories.fetch()
    @$('#location').val(App.user.get('location'))
    @$('#team').val(App.teams.get(App.user.get('team_id')).get('name') if App.user.get('team_id')?)
    this
########################################################################################################################

######################################## $ Submit Service Request $ ####################################################
  submitServiceRequest: (e) ->
    e.preventDefault() if e?
    #return if @validate()
    App.fh.displayFlash("info", "Espere por favor...", 2000)
    @$('#submit-service-request').attr('disabled', true)
    @$('#submit-service-request').html('<i class="icon-load"></i>  Espere por favor...')
    category1 = @$('#category').val()
    category2 = @$('#category2').val()
    category3 = @$('#category3').val()
    if category2 == "" then category2 = "SSC"
    if category3 == "" then category3 = "STC"
    category_id = App.categories.where({category1: category1, category2: category2, category3: category3})[0].id
    service_request =
      asigned_to_id   : @$('#asigned_to').val()
      category_id     : category_id
      creator_id      : App.user.id
      description     : @$('#description').val()
      location        : @$('#location').val()
      priority        : "Baja"
      status          : "Nuevo"
      title           : @$('#title').val()
      modified_by     : App.user.id
    @model.save service_request, success: =>
      App.serviceRequests.add(@model)
      if @notes.length > 0
        for note, i in @notes.models
          note.set('table_name_id', @model.id)
          note.save null, success: =>
            Backbone.history.navigate("service_requests/show/#{@model.id}", trigger = true) if i == @notes.length
      else
        Backbone.history.navigate("service_requests/show/#{@model.id}", trigger = true)
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
    model.set(attributes.note)
    view = new App.Views.NoteShow(model: model)
    App.pushToAppendedViews(view)
    @$('#notes').append(view.render().el)
    @notes.add(model)
    @$('#new-note').focus()
    this
########################################################################################################################

############################################## $ Set Categories $ ######################################################
  setCategories: ->
    cats = App.categories.pluckDistinct('category1')
    for cat in cats
      @$('#category').append("<option>#{cat}</option>")
    this

  changeSubCategories: ->
    @$('#category2').empty()
    @$('#category2').append("<option>Seleccione una Subcategoría</option>")
    @$('#category3').empty()
    @$('#category3').append("<option>Seleccione una Tercer Categoría</option>")
    ssc = stc = 0
    category = @$('#category').val()

    subs = App.categories.pluckDistinct("category2", {category1: category})
    for sub in subs
      if sub == "SSC"
        @$('#category2').append("<option></option>") if ssc == 0
        ssc = stc = 1
      else
        @$('#category2').append("<option>#{sub}</option>")

    this

  changeThirdCategories: ->
    @$('#category3').empty()
    @$('#category3').append("<option>Seleccione una Tercer Categoría</option>")
    stc = 0
    category = @$('#category').val()
    if @$('#category2').val() == ''
      @$('#category3').append("<option></option>")
      return @$('#category3').val('')
    subcategory = @$('#category2').val()
    if subcategory == "" then subcategory = "SSC"
    ters = App.categories.pluckDistinct("category3", {category1: category, category2: subcategory})
    if ters.length == 1 and ters[0] == "STC"
      @$('#category3').append("<option></option>")
      return @$('#category3').val('')
    for ter in ters
      if ter == "STC"
        @$('#category3').append("<option></option>") if stc == 0
        stc = 1
      else
        @$('#category3').append("<option>#{ter}</option>")
    this
########################################################################################################################