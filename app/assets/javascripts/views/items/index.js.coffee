class App.Views.ItemIndex extends Backbone.View
  template: JST['items/index']
  className: 'span12'
  name: 'IndexItem'

  events:
    'click #new-item'         : 'newItem'
    'click #fetch-deliveries' : 'fetchDeliveries'

  render: ->
    $(@el).html(@template())
    App.items.each(@appendItem)
    this

  appendItem: (model) =>
    view = new App.Views.Item(model: model)
    App.pushToAppendedViews(view)
    @$('#items').append(view.render().el)
    this

  newItem: (e) ->
    e.preventDefault()
    Backbone.history.navigate 'items/new', trigger: true
    this

  fetchDeliveries: (e) ->
    e.preventDefault()
    @$('#fetch-deliveries').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.items.fetch success: =>
      @$('#fetch-deliveries').html('Actualizar').removeClass('loading')
      App.items.each(@appendItem)
    this