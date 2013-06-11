class App.Views.PurchaseRequestCreate extends Backbone.View
  template: JST['purchase_request/create']
  className: 'span12'
  name: 'CreatePurchaseRequest'

  events:
    'click #submit-create-purchase-request'     : 'createPurchaseRequest'
    'click #sector-options li a'                : 'selectSector'
    'focus #detail'                             : 'showWYSIHTML5'
    'focus #sector'                             : 'typeAheadSector'
    'keydown #sector'                           : 'keyHelperDown'
    'keydown #use'                              : 'keyHelperDown'
    'keydown #deliver_at'                       : 'keyHelperUp'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @sector = []
    @formHelper = new App.Mixins.Form
    nowTemp = new Date()
    @fiveDays = @formHelper.addDays(nowTemp, 4).split('-')
    @shown = 0
    App.formHelpers.where({column: 'location'}).forEach (e) => @sector.push e.get('value')
    App.teams.each (e) => @sector.push e.get('name')
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    console.log @fiveDays
    $(@el).html(@template())
    @$('.datepicker').datepicker({format: 'dd-mm-yyyy'}).on 'changeDate', (e) =>
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd' }).on 'changeDate', (e) =>
      @$(e.target).datepicker('hide')
#      @$('#notice').html('')
#      date = @formHelper.addDays(e.date, 1).split('-')
#      console.log date
#      if @fiveDays[0] < date[0]
#        return @$('#detail').focus()
#      else if @fiveDays[1] < date[1]
#        return @$('#detail').focus()
#      else if @fiveDays[2] < date[2]
#        return @$('#detail').focus()
#      else
#        @$(e.target).val('')
#        return @formHelper.displayFlash('alert', 'Debe dar por lo menos 5 días a partir de hoy a la Fecha de Entrega. Por favor corrijala.', 100000)
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
    cost_center = team.get('cost_center')
    if App.user.id == team.get('supervisor_id') or App.user.id == team.get('director_id')
      state    = "Visto"
      approver = App.user.id
    else
      state    = "Pendiente"
      approver = null
    purchaseRequest =
        user_id     : App.user.get('id')
        sector      : @$('#sector').val()
        deliver_at  : @$('#deliver_at').val()
        use         : @$('#use').val()
        detail      : @$('#detail').val()
        state       : state
        approver    : approver
        cost_center : cost_center
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
    alert = []
    if @$('#use').val() == ''
      @highlightError('use')
      alert.push('El campo "Compra de" no puede quedar vacío')
    unless @sector.indexOf(@$('#sector').val()) > -1
      @highlightError('sector')
      alert.push('Debe seleccionar un sector de la lista.')
    if @$('#deliver_at').val() == ''
      @highlightError('deliver_at')
      alert.push('Debe seleccionar una fecha de entrega')
    if @$('#detail').val() == ''
      @highlightError('detail')
      alert.push('El contenido de su pedido no puede quedar vacío.')
    $("html, body").animate({ scrollTop: 0 }, "slow")
    if alert.length > 0
      @formHelper.displayListFlash('danger', alert, 0)
      return true
    else
      return false
########################################################################################################################

########################################## $ Higlight Error $ ##########################################################
  highlightError: (id) ->
    @$("label[for='#{id}']").removeClass('label-inverse').addClass('label-important')
    @$('#' + id).addClass('error')
    this
########################################################################################################################

######################################### $ Remove Highlight $ #########################################################
  removeHighlight: ->
    @$('.control-group').removeClass('error')
    @$('.label-important').removeClass('label-important').addClass('label-inverse')
    @$('.alert').remove()
    @$('input').removeClass('error')
    this
########################################################################################################################

############################################ $ Key Helper $ ############################################################
  keyHelperDown: (e) ->
    switch  e.keyCode
      when 13
        switch e.currentTarget.id
          when 'sector'
            e.preventDefault()
            @$('#deliver_at').focus()
            break
          when 'deliver_at'
            e.preventDefault()
            @$('#detail').focus()
            @$('#deliver_at').datepicker('hide')
            break
          when 'use'
            e.preventDefault()
            @$('#sector').focus()
            break
        break
      when 9
        switch e.currentTarget.id
          when 'deliver_at'
            e.preventDefault()
            @$('#detail').focus()
            @$('#deliver_at').datepicker('hide')
            break
        break
    console.log e.currentTarget.id
    this
########################################################################################################################

############################################## $ Select Sector $ #######################################################
  selectSector: (e) ->
    value =  e.currentTarget.text
    return if value == 'Locales' or value == 'Equipos'
    e.preventDefault if e?
    @$('#sector').val(value)
    @$('#deliver_at').focus()
########################################################################################################################

############################################## $ Key Helper Up $ #######################################################
  keyHelperUp: (e) ->
    e.preventDefault()
    if e.currentTarget.id == "deliver_at"
      @$('#deliver_at').val('')
    #@$('#deliver_at').datepicker('show')
    this
