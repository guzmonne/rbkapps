class App.Views.PurchaseRequestCreate extends Backbone.View
  template: JST['purchase_request/create']
  className: 'span12'
  name: 'CreatePurchaseRequest'

  events:
    'click #submit-create-purchase-request'     : 'createPurchaseRequest'
    'click #add-new-line'                       : 'addNewLine'
    'click #add-new-unit'                       : 'addNewUnit'
    'submit #add-new-unit-form'                 : 'addNewUnit'
    'keydown :input'                            : 'keyHelper'
########################################################################################################################

############################################## $ Initialize $ ##########################################################
  initialize: ->
    @formHelper = new App.Mixins.Form
    @listenTo App.vent, 'removePurchaseRequestLine:success', @removeModel
########################################################################################################################

################################################ $ Render $ ############################################################
  render: ->
    view = new App.Views.PurchaseRequestLineCreate
    App.pushToAppendedViews(view)
    $(@el).html(@template()).find('#purchase-request-lines').html(view.render().el)
    @$('.select2').select2({width: 'copy'})
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on 'changeDate', (e) =>
      @$(e.target).datepicker('hide')
      @$('#use').focus()
    this
########################################################################################################################

######################################## $ Create Purchase Request $ ###################################################
  createPurchaseRequest: (e) ->
    e.preventDefault()
    return if @validate()
    @formHelper.displayFlash("info", "Espere por favor...", 2000)
    $('#submit-create-purchase-request').attr('disabled', true)
    $('#submit-create-purchase-request').html('<i class="icon-load"></i>  Espere por favor...')
    @lines = []
    @model.lines.each (model) =>
      line =
          description: model.get('description')
          unit:        model.get('unit')
          quantity:    model.get('quantity')
      @lines.push(line)
    purchaseRequest =
        user_id:    App.user.get('id')
        sector:     $('#sector').val()
        deliver_at: $('#deliver_at').val()
        use:        $('#use').val()
        team_id:    $('#team').find('option:selected').data('id')
        state:      'Esperando Aprovación'
    attributes =
      purchase_request: purchaseRequest
      purchase_request_lines: @lines
    @model.save attributes, success: =>
      App.purchaseRequests.add(@model)
      Backbone.history.navigate("purchase_request/show/#{@model.id}", trigger = true)
########################################################################################################################

############################################# $ Handle Success $ #######################################################
  handleSuccess: (data) =>
    @formHelper.cleanForm('#create-purchase-request')
    @model.lines.each((model) => @saveModel())
########################################################################################################################

############################################## $ Save Model $ ##########################################################
  saveModel: (model) =>
    model.set('purchase_request_id', @model.get('id'))
    model.save()
    @model.lines.remove(model)
    return
########################################################################################################################

############################################# $ Add New Line $ #########################################################
  addNewLine: (e) ->
    e.preventDefault()
    model = new App.Models.PurchaseRequestLine()
    attributes =
      description: $('#description').val()
      unit: $('#unit').val()
      quantity: $('#quantity').val()
    model.set(attributes)
    showView = new App.Views.PurchaseRequestLineShow(model: model)
    App.pushToAppendedViews(showView)
    @formHelper.cleanForm('#add-new-line-form')
    @$('tbody').append(showView.render().el)
    #$('#purchase-request-form-row').after(showView.render().el)
    $('#description').focus()
    @model.lines.add(model)
########################################################################################################################

############################################ $ Remove Model $ ##########################################################
  removeModel: (model) ->
    @model.lines.remove(model)
########################################################################################################################

########################################### $ Add New Unit $ ###########################################################
  addNewUnit: (e) ->
    e.preventDefault()
    $('#add-new-unit-modal').modal('toggle')
    newUnit = $('#new-unit').val()
    if newUnit == "" then return @
    $('#new-unit').val('')
    $('#unit').prepend("<option>#{newUnit}</option>")
    $('#unit').val(newUnit)
    this
########################################################################################################################

############################################# $ Validate $ #############################################################
  validate: ->
    @removeHighlight()
    alert = 0
    if $('#team').val() == "Seleccione un Equipo de la Lista"
      @highlightError('team')
      @formHelper.displayFlash('error', 'Seleccione un equipo de la lista', 10000)
      alert++
    if $('#sector').val() == ''
      @highlightError('sector')
      @formHelper.displayFlash('error', 'El campo "Sector" no puede quedar vacío', 10000)
      alert++
    if $('#deliver_at').val() == ''
      @highlightError('deliver_at')
      @formHelper.displayFlash('error', 'El campo "Necesario para" no puede quedar vacío', 10000)
      alert++
    if $('#use').val() == ''
      @highlightError('use')
      @formHelper.displayFlash('error', 'El campo "Uso del Material" no puede quedar vacío', 10000)
      alert++
    if @model.lines.length == 0
      @formHelper.displayFlash('error', 'Debe ingresar al menos un elemento en la solicitud', 10000)
      alert++
    if alert > 0 then return true else return false
########################################################################################################################

########################################## $ Higlight Error $ ##########################################################
  highlightError: (id) ->
    @$('#' + id).parent().addClass('control-group error').find('label').removeClass('label-inverse').addClass('label-important').css('color', '#FFFFFF')
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
    console.log e
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