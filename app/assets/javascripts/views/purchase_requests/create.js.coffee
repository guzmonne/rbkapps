class App.Views.PurchaseRequestCreate extends Backbone.View
  template: JST['purchase_request/create']
  className: 'span12'
  name: 'CreatePurchaseRequest'

  events:
    'click #submit-create-purchase-request': 'createPurchaseRequest'
    'click #add-new-line': 'addNewLine'
    'click #add-new-unit': 'addNewUnit'
    'submit #add-new-unit-form': 'addNewUnit'

  initialize: ->
    @formHelper = new App.Mixins.Form
    @listenTo App.vent, 'removePurchaseRequestLine:success', @removeModel

  render: ->
    view = new App.Views.PurchaseRequestLineCreate
    App.pushToAppendedViews(view)
    $(@el).html(@template()).find('#purchase-request-lines').html(view.render().el)
    @$('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on 'changeDate', (e) ->
      $(e.target).datepicker('hide')
      $('#use').focus()
    this

  createPurchaseRequest: (e) ->
    e.preventDefault()
    if $('#team').val() == "Seleccione un Equipo de la Lista"
      $('#team').parent().addClass('control-group error')
      return @formHelper.displayFlash('error', 'Seleccione un equipo de la lista', 10000)
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

  handleSuccess: (data) =>
    @formHelper.cleanForm('#create-purchase-request')
    @model.lines.each((model) => @saveModel())

  saveModel: (model) =>
    model.set('purchase_request_id', @model.get('id'))
    model.save()
    @model.lines.remove(model)
    return

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
    $('#purchase-request-form-row').after(showView.render().el)
    $('#description').focus()
    @model.lines.add(model)

  removeModel: (model) ->
    @model.lines.remove(model)

  addNewUnit: (e) ->
    e.preventDefault()
    $('#add-new-unit-modal').modal('toggle')
    newUnit = $('#new-unit').val()
    if newUnit == "" then return @
    $('#new-unit').val('')
    $('#unit').prepend("<option>#{newUnit}</option>")
    $('#unit').val(newUnit)
    this
