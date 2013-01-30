class App.Views.PurchaseRequest extends Backbone.View
  template: JST['purchase_request/purchase_request']
  tagName: 'tr'
  name: 'PurchaseRequest'

  events:
    'click': 'show'

  initialize: ->
    @dateHelper = new App.Mixins.Date

  render: ->
    $(@el).html(@template(model: @model, dateHelper: @dateHelper))
    this

  show: ->
    Backbone.history.navigate("purchase_request/show/#{@model.id}", true)
    this