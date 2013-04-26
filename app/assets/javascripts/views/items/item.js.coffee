class App.Views.Item extends Backbone.View
  template: JST['items/item']
  tagName: 'tr'
  name: 'Item'
  className: (options) ->
    if @collection?
      if App.colHelper.colHasDupes(@collection.pluck('code')).indexOf(@model.get('code')) > -1 then 'row-danger'

  initialize: (options) ->
    @listenTo App.vent, 'delivery:create:success', => @remove()
    @listenTo App.vent, 'update:items:success', => @remove()
    @listenTo App.vent, 'new:report:success', => @remove()
    @array =  options['array'] if options?

  events:
    'click #remove-item': 'removeItem'

  render: ->
    $(@el).html(@template(model: @model))
    this

  removeItem: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar este artículo")
    if result
      App.vent.trigger 'remove:item:success', @model
      @model.destroy()
      @remove()

  removeHideButton: ->
    @$('#remove-item').remove()
    this

  rowDangerClass: ->
    $(@el).addClass('row-danger')
    this
