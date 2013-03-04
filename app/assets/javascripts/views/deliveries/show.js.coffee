class App.Views.DeliveryShow extends App.Views.DeliveryCreate
  template: JST['deliveries/show']
  name: 'DeliveryShow'
  className: 'span12'

  'events': _.extend({
    'click #submit-save-delivery' : 'saveChanges'
    'keyup :input'                : 'changeInput'
    'click #reset-form'           : 'resetForm',
  }, App.Views.DeliveryCreate.prototype.events)

  initialize: ->
    @savedModel = @model
    @listenTo App.vent, "delivery:show:render:success", => @populateFields()

  render: ->
    $(@el).html(@template(model: @model))
    @model.invoices.each(@renderInvoice)
    @model.items.each(@renderItem)
    App.vent.trigger "delivery:show:render:success"
    this

  renderInvoice: (invoice) =>
    view = new App.Views.Invoice(model: invoice)
    App.pushToAppendedViews(view)
    @$('#invoice-form-row').after(view.render().el)
    # @$('#remove-invoice').hide()
    this

  renderItem: (item) =>
    view = new App.Views.Item(model: item)
    App.pushToAppendedViews(view)
    @$('#item-form-row').after(view.render().el)
    # @$('#remove-item').hide()
    this

  populateFields: (e) =>
    for attribute of @model.attributes
      @$('#' + attribute).val(@model.get(attribute))
    @changeCourierIcon()
    @toggleGuides()
    @$('#item-search-row').hide()
    @$('#search-items').show()
    @$('#invoice-search-row').hide()
    @$('#search-invoices').show()
    @$('.select2').select2({width: 'copy'})
    this

  saveChanges: (e) ->
    e.preventDefault()
    alert "Save Changes!"

  changeInput: (e) ->
    console.log e.currentTarget.id

  resetForm: (e) ->
    e.preventDefault()
    @render()