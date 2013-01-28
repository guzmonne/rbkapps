class App.Views.PurchaseRequestCreate extends Backbone.View
  template: JST['purchase_request/create']
  className: 'span12'
  name: 'CreatePurchaseRequest'

  events:
    'click #submit-create-purchase-request': 'createPurchaseRequest'
    'click #add-new-line': 'addNewLine'

  initialize: ->
    @formHelper = new App.Mixins.Form
    @collection = new App.Collections.PurchaseRequestLines()
    App.vent.on 'removePurchaseRequestLine:success', @removeModel, this

  render: ->
    view = new App.Views.PurchaseRequestLineCreate
    App.pushToAppendedViews(view)
    $(@el).html(@template()).find('#purchase-request-lines').html(view.render().el)
    this

  createPurchaseRequest: (e) ->
    e.preventDefault()
    attributes =
      purchase_request:
        user_id:    App.user.get('id')
        sector:     $('#sector').val()
        deliver_at: $('#deliver_at').val()
        use:        $('#use').val()
        team_id:    $('#team_id').val()
        state:      'Esperando Aprovación'
    @model.save(attributes, {success: @handleSuccess, error: @handleError})


  handleSuccess: (data) =>
    console.log data
    @formHelper.cleanForm('#create-purchase-request')
    @collection.each(@saveModel)
    Backbone.history.navigate("purchase_request/show/#{@model.get('id')}", trigger: true)

  handleError: (data, status, response) =>
    this

  saveModel: (model) =>
    model.set('purchase_request_id', @model.get('id'))
    model.save({success: @handleSaveModelSuccess, error: @handleSaveModelError})
    @removeModel(model)

  handleSaveModelSuccess: (data) ->
    this

  handleSaveModelError: (data, status, response) =>
    this

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
    $('#purchase-request-form-row').before(showView.render().el)
    $('#description').focus()
    @collection.add(model)

  removeModel: (model) ->
    @collection.remove(model)
