class App.Views.PurchaseRequest extends Backbone.View
  template: JST['purchase_request/purchase_request']
  tagName: 'tr'
  name: 'PurchaseRequest'

  events:
    'click': 'show'

  initialize: ->
    @dateHelper = new App.Mixins.Date
    @model.set('team', App.teams.getNameFromId(@model.get('team_id')))
    @listenTo App.vent, 'update:purchase_requests:success', => @remove()

  render: ->
    $(@el).html(@template(model: @model, dateHelper: @dateHelper))
    this

  show: ->
    Backbone.history.navigate("purchase_request/show/#{@model.id}", true)
    this