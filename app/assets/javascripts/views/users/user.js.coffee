class App.Views.User extends Backbone.View
  template: JST['users/user']
  tagName: 'tr'
  name: 'User'

  initialize: ->
    @listenTo App.vent, 'update:users', => @remove()

  render: ->
    $(@el).html(@template(model: @model))
    if @model.get('admin') == true
      @$(".admin").html('<i class="icon-ok"></i>')
    if @model.get('comex') == true
      @$(".comex").html('<i class="icon-ok"></i>')
    if @model.get('compras') == true
      @$(".compras").html('<i class="icon-ok"></i>')
    this