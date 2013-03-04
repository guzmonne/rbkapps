class App.Views.DeliveryShow extends App.Views.DeliveryCreate
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  initialize: ->


  render: ->
    $(@el).html(@template()).find('.' + @model.get('dispatch')).fadeIn('fast')
    @model.invoices.each(@renderInvoice)
    @model.items.each(@renderItem)
    for attribute of @model.attributes
      $('#' + attribute).val(@model.attributes[attribute])
      console.log $('#' + attribute).val(@model.attributes[attribute])
    this

  renderInvoice: (invoice) =>
    view = new App.Views.Invoice(model: invoice)
    App.pushToAppendedViews(view)
    @$('#invoice-form-row').after(view.render().el)
    @$('#remove-invoice').hide()
    this

  renderItem: (item) =>
    view = new App.Views.Item(model: item)
    App.pushToAppendedViews(view)
    @$('#item-form-row').after(view.render().el)
    @$('#remove-item').hide()
    this

