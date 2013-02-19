class App.Views.DeliveryShow extends Backbone.View
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  initialize: (options) ->
    @item = options.item
    @invoices = @model.invoices

  render: ->
    $(@el).html(@template(model: @model, item: @item, invoices: @invoices))
    @invoices.each(@renderLine)
    console.log @invoices
    this

  renderLine: (invoice) =>
    view = new App.Views.Invoice(model: invoice)
    App.pushToAppendedViews(view)
    @$('#invoices').append(view.render().el)