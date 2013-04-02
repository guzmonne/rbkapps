class App.Views.PurchaseRequestCreate extends Backbone.View
  template: JST['purchase_request/create']
  className: 'span12'
  name: 'CreatePurchaseRequest'

  events:
    'click #submit-create-purchase-request'     : 'createPurchaseRequest'
    'click #sector-options li a'                : 'selectSector'
    'focus #detail'                             : 'showWYSIHTML5'
    'focus #sector'                             : 'typeAheadSector'
    'keydown :input'                            : 'keyHelper'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @sector = []
    @formHelper = new App.Mixins.Form
    @shown = 0
    App.formHelpers.where({column: 'location'}).forEach (e) => @sector.push e.get('value')
    App.teams.each (e) => @sector.push e.get('name')
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    $(@el).html(@template())
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on 'changeDate', (e) =>
      @$(e.target).datepicker('hide')
      @$('#use').focus()
    this
########################################################################################################################

############################################ $ Type Ahead Sector $ #####################################################
  typeAheadSector: ->
    @$('#sector').typeahead source: =>
      @sector
    this
########################################################################################################################

######################################## $ Create Purchase Request $ ###################################################
  showWYSIHTML5: ->
    return if @shown == 1
    @$('#detail').wysihtml5()
    @shown = 1
    this
########################################################################################################################

######################################## $ Create Purchase Request $ ###################################################
  createPurchaseRequest: (e) ->
    e.preventDefault()
    return if @validate()
    @formHelper.displayFlash("info", "Espere por favor...", 2000)
    @$('#submit-create-purchase-request').attr('disabled', true)
    @$('#submit-create-purchase-request').html('<i class="icon-load"></i>  Espere por favor...')
    team = App.teams.get(App.user.get('team_id'))
    if App.user.id == team.get('supervisor_id') or App.user.id == team.get('director_id')
      state = "Aprobado"
    else
      state = "Esperando Aprobación"
    purchaseRequest =
        user_id     : App.user.get('id')
        sector      : @$('#sector').val()
        deliver_at  : @$('#deliver_at').val()
        use         : @$('#use').val()
        detail      : @$('#detail').val()
        state       : state
    console.log purchaseRequest
    @model.save purchaseRequest, success: =>
      App.purchaseRequests.add(@model)
      Backbone.history.navigate("purchase_request/show/#{@model.id}", trigger = true)
########################################################################################################################

############################################# $ Handle Success $ #######################################################
  handleSuccess: (data) =>
    @formHelper.cleanForm('#create-purchase-request')
########################################################################################################################

############################################ $ Validate Sector$ ########################################################
  validateSector: ->
    console.log "Validate Sector"
    if @sector.indexOf('Sam') > -1
      @$("label[for='sector']").removeClass('label-important').addClass('label-inverse')
    else
      @$("label[for='sector']").removeClass('label-inverse').addClass('label-important')
      @formHelper.displayFlash('error', 'Debe seleccionar un sector de la lista', 10000)
    this
########################################################################################################################

############################################# $ Validate $ #############################################################
  validate: ->
    @removeHighlight()
    @$("label[for='sector']").removeClass('label-important').addClass('label-inverse')
    alert = 0
    unless @sector.indexOf(@$('#sector').val()) > -1
      @highlightError('sector', 'Debe seleccionar un elemento de la lista.')
      alert++
    if @$('#deliver_at').val() == ''
      @highlightError('deliver_at', 'Debe seleccionar una fecha de entrega')
      alert++
    if @$('#use').val() == ''
      @highlightError('use', 'El campo "Compra de" no puede quedar vacío')
      alert++
    if alert > 0 then return true else return false
########################################################################################################################

########################################## $ Higlight Error $ ##########################################################
  highlightError: (id, text) ->
    @$("label[for='#{id}']").removeClass('label-inverse').addClass('label-important')
    @formHelper.displayFlash('error', text, 10000)
    @$('#' + id).focus()
    this
########################################################################################################################

######################################### $ Remove Highlight $ #########################################################
  removeHighlight: ->
    @$('.control-group').removeClass('error')
    @$('.label-important').removeClass('label-important').addClass('label-inverse')
    @$('.alert').remove()
    this
########################################################################################################################

############################################ $ Key Helper $ ############################################################
  keyHelper: (e) ->
    switch  e.keyCode
      when 13
        switch e.currentTarget.id
          when 'sector'
            e.preventDefault()
            @$('#deliver_at').focus()
            break
          when 'deliver_at'
            e.preventDefault()
            @$('#use').focus()
            @$('#deliver_at').datepicker('hide')
            break
          when 'use'
            e.preventDefault()
            @$('#team').focus()
            break
          when 'team'
            e.preventDefault()
            @$('#description').focus()
            break
        switch e.currentTarget.className
          when 'select2-focusser select2-offscreen'
            e.preventDefault()
            @$('#description').focus()
            break
        break
      when 9
        switch e.currentTarget.id
          when 'deliver_at'
            e.preventDefault()
            @$('#use').focus()
            @$('#deliver_at').datepicker('hide')
            break
        switch e.currentTarget.className
          when 'select2-focusser select2-offscreen'
            e.preventDefault()
            @$('#description').focus()
            break
        break
    this
########################################################################################################################

############################################## $ Select Sector $ #######################################################
  selectSector: (e) ->
    value =  e.currentTarget.text
    return if value == 'Locales' or value == 'Equipos'
    e.preventDefault if e?
    @$('#sector').val(value)
