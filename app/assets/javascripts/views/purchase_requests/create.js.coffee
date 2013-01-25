class App.Views.PurchaseRequestCreate extends Backbone.View
  template: JST['purchase_request/create']
  className: 'span12'
  name: 'CreatePurchaseRequest'

  events:
    'submit #create-session': 'createPurchaseRequest'
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
    attributes = $('#create-purchase-request').serialize()
    console.log attributes
    console.log $('#create-purchase-request')

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
    $('tbody').prepend(showView.render().el)
    $('#description').focus()
    @collection.add(model)
    console.log @collection, @collection.length

  removeModel: (model) ->
    #$('#line-' + cid).remove()
    @collection.remove(model)
    console.log @collection, @collection.length
