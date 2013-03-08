class App.Views.User extends Backbone.View
  template: JST['users/user']
  tagName: 'tr'
  name: 'User'

  events:
    'click': 'show'

  initialize: ->
    @listenTo App.vent, 'update:users', => @remove()

  render: ->
    $(@el).html(@template(model: @model))
    if @model.get('admin') == true
      @$(".admin").html('<i class="icon-ok"></i>')
    if @model.get('comex') == true
      @$(".comex").html('<i class="icon-ok"></i>')
    this

  show: ->
    Backbone.history.navigate("users/show/#{@model.id}", true)
    this