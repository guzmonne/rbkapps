class App.Views.ItemIndex extends Backbone.View
  template: JST['items/index']
  className: 'span12'
  name: 'IndexItem'

  render: ->
    $(@el).html(@template())
    App.items.each(@appendItem)
    this

  appendItem: (model) =>
    view = new App.Views.Item(model: model)
    App.pushToAppendedViews(view)
    @$('#items').append(view.render().el)
    this