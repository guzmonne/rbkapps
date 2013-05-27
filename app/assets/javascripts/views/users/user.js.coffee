class App.Views.User extends Backbone.View
  template: JST['users/user']
  tagName: 'tr'
  name: 'User'

  initialize: ->
    @listenTo App.vent, 'update:users', => @remove()

  events:
    'mouseover'     : 'iconWhite'
    'mouseout'      : 'iconWhite'
    'dblclick'      : 'edit'

  render: ->
    $(@el).html(@template(model: @model))
    if @model.get('admin') == true
      @$(".admin").html('<i class="icon-ok"></i>')
    if @model.get('comex') == true
      @$(".comex").html('<i class="icon-ok"></i>')
    if @model.get('compras') == true
      @$(".compras").html('<i class="icon-ok"></i>')
    if @model.get('director') == true
      @$(".director").html('<i class="icon-ok"></i>')
    if @model.get('maintenance') == true
      @$(".maintenance").html('<i class="icon-ok"></i>')
    this

  iconWhite: (e) ->
    @$('i').toggleClass('icon-white')
    this

  edit: ->
    Backbone.history.navigate("users/edit/#{@model.id}", true)
    this