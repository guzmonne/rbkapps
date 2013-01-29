class App.Views.PurchaseRequest extends Backbone.View
  template: JST['purchase_request/purchase_request']
  tagName: 'tr'
  name: 'PurchaseRequest'

  events:
    'click': 'show'

  initialize: ->
    @dateHelper = new App.Mixins.Date
    @model.set('created_at', @dateHelper.parseRailsDate(@model.get('created_at')))
    @model.set('updated_at', @dateHelper.parseRailsDate(@model.get('updated_at')))

  render: ->
    $(@el).html(@template(model: @model))
    this

  show: ->
    Backbone.history.navigate("purchase_request/show/#{@model.id}", true)