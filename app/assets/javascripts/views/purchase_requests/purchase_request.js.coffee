class App.Views.PurchaseRequest extends Backbone.View
  template: JST['purchase_request/purchase_request']
  tagName: 'tr'
  name: 'PurchaseRequest'

  events:
    'dblclick': 'show'

  initialize: ->
    @dateHelper = new App.Mixins.Date
    @model.set('team', App.teams.getNameFromId(@model.get('team_id')))
    @listenTo App.vent, 'update:purchase_requests:success', => @remove()
    # Resuelvo el nombre del usuario creador
    @model.set('user_name',  App.users.get(@model.get('user_id')).get('name'))
    # Resuelvo nombre del aprobador
    if @model.get('approver')?
      @approver = App.users.get(@model.get('approver'))
      @model.set('approved_by', @approver.get('name'))
    else
      @model.set('approved_by', "S/A")
    # Resuelvo nombre del autorizador
    if @model.get('authorizer_id')?
      @authorizer = App.users.get(@model.get('authorizer_id'))
      @model.set('authorizer', @authorizer.get('name'))
    else
      @model.set('authorizer', "S/A")

  render: ->
    $(@el).html(@template(model: @model, dateHelper: @dateHelper, @user))
    this

  show: ->
    Backbone.history.navigate("purchase_request/show/#{@model.id}", true)
    this