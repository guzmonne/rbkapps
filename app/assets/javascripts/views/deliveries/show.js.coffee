class App.Views.DeliveryShow extends App.Views.DeliveryCreate
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  initialize: ->
    @suppliers   = App.deliveries.pluckDistinct('supplier')
    @origins     = App.deliveries.pluckDistinct('origin')
    @brands      = App.items.pluckDistinct('brand')
    @seasons     = App.items.pluckDistinct('season')
    @entries     = App.items.pluckDistinct('entry')
    @codes       = App.items.pluck('code')
    @invoices    = App.invoices.pluck('invoice_number')

  render: ->
    attributes =
      suppliers : @suppliers
      origins   : @origins
      brands    : @brands
      seasons   : @seasons
      entries   : @entries
      model     : @model
    $(@el).html(@template(attributes)).find('.' + @model.get('dispatch')).fadeIn('fast')
    @model.invoices.each(@renderInvoice)
    @model.items.each(@renderItem)
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
