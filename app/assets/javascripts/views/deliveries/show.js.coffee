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

  events:
    'change #courier_select'                   : 'changeCourierIcon'
    'change #dispatch_select'                  : 'toggleGuides'
    'click #add-new-supplier'                  : 'addNewSupplier'
    'click #submit-new-supplier'               : 'addNewSupplier'
    'click #add-new-origin'                    : 'addNewOrigin'
    'click #submit-new-origin'                 : 'addNewOrigin'
    'click #add-new-invoice'                   : 'addNewInvoice'
    'click #add-new-item'                      : 'addNewItem'
    'keydown :input'                           : 'keyDownManager'
    'click #clear-form'                        : 'clearForm'
    'click #toggle-items-form'                 : 'toggleItemsForm'
    'click #close-item-form'                   : 'toggleItemsForm'
    'click #toggle-invoice-form'               : 'toggleInvoiceForm'
    'click #close-invoice-form'                : 'toggleInvoiceForm'
    'click #add-new-brand'                     : 'addNewItemElement'
    'click #add-new-season'                    : 'addNewItemElement'
    'click #add-new-entry'                     : 'addNewItemElement'
    'click #search-items'                      : 'searchItems'
    'click #close-searched-item'               : 'searchItems'
    'change #searched-item-code'               : 'displaySearchedItem'
    'click #add-searched-item'                 : 'addSearchedItem'
    'click #search-invoices'                   : 'searchInvoices'
    'click #close-searched-invoice'            : 'searchInvoices'
    'change #searched-invoice-invoice_number'  : 'displaySearchedInvoice'
    'click #add-searched-invoice'              : 'addSearchedInvoice'
    'focus #searched-invoice-invoice_number'   : 'typeaheadInvoice'
    'click #edit-delivery'                     : 'editDelivery'

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

  changeCourierIcon: (e) ->
    courier = $('#courier_select').val()
    if courier == "Seleccione una Empresa" then return $('#courier-logo')[0].src = "/assets/rails.png"
    $('#courier-logo')[0].src = "/assets/#{courier}.png"
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

  editDelivery: (e) ->
    e.preventDefault()
    $("[readonly]").attr("readonly", false);
    $('.btn-mini').show()
    $('.select').hide()
    $('#courier_select').show().val(@model.get('courier'))
    $('#dispatch_select').show().val(@model.get('dispatch'))
    $('#supplier_select').show().val(@model.get('supplier'))
    $('#origin_select').show().val(@model.get('origin'))
    $('#courier_select').focus()