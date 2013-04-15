class App.Views.Invoice extends Backbone.View
  template: JST['invoices/invoice']
  tagName: 'tr'
  name: 'Invoice'
  id: ->
    @model.cid
  className: ->
    unless @model.get('delivery_id') then 'row-warning'

  events:
    'click #remove-invoice'       : 'removeInvoice'
    'click #add-item-to-invoice'  : 'showInvoice'
    'mouseover'                   : 'iconWhite'
    'mouseout'                    : 'iconBlack'
########################################################################################################################

################################################## $ Initialize $ ######################################################
  initialize: ->
    @fH = new App.Mixins.Form
    @model.set('fob_total_cost', @fH.correctDecimal(@model.get('fob_total_cost')))
    @listenTo App.vent, 'delivery:create:success', => @remove()
    @listenTo App.vent, 'remove:invoices', => @remove()
    @listenTo App.vent, 'update:invoices:success', => @remove()
    @listenTo App.vent, "invoice:create:success", (model) =>
      return unless model.id == @model.id
      @remove()
    @listenTo App.vent, "edit:invoice:success", (model) =>
      return unless model.id == @model.id
      view = new App.Views.CreateInvoice(model: @model)
      App.pushToAppendedViews()
      @$('.show-invoice').append(view.renderShow().el)
      view.hideSearchButton()
      view.hideCloseButton()
    @listenTo App.vent, "remove:createInvoice:success", (model) =>
      return unless model.id == @model.id
      view = new App.Views.InvoiceShow(model: @model)
      App.pushToAppendedViews()
      @$('.show-invoice').append(view.render().el)
      view.hideCloseButton()
    @listenTo App.vent, "minimize:invoice:success", (model) =>
      return unless model.id == @model.id
      @remove()
    @listenTo App.vent, "remove:invoiceShow:success", (model) =>
      return unless model.id == @model.id
      @remove()
########################################################################################################################

#################################################### $ Render $ ########################################################
  render: ->
    $(@el).html(@template(invoice: @model))
    unless @model.get('delivery_id') then  @$('.without_delivery').html('<i class="icon-ok"></i>')
    this
########################################################################################################################

################################################ $ Remove Invoice $ ####################################################
  removeInvoice: (e) ->
    e.preventDefault()
    result = confirm("Esta seguro que desea eliminar esta factura?")
    if result
      App.vent.trigger 'remove:invoice:success', @model
      @remove()
########################################################################################################################

################################################# $ Show Invoice $ #####################################################
  showInvoice: ->
    @model.invoice_items.fetch
      data:
        invoice_id: @model.id
      success: =>
        view = new App.Views.InvoiceShow(model: @model)
        App.pushToAppendedViews()
        $(@el).html('<td colspan="6" class="show-invoice"></td>')
        @$('.show-invoice').append(view.render().el)
        view.hideCloseButton()
########################################################################################################################

############################################## $ Show Create View $ ####################################################
  showCreateView: =>
    view = new App.Views.CreateInvoice(model: @model)
    App.pushToAppendedViews()
    @$('.show-invoice').append(view.renderShow().el)
########################################################################################################################

################################################ $ Paint Icon $ ########################################################
  iconWhite: ->
    @$('.icon-ok').addClass('icon-white')
    this
  iconBlack: ->
    @$('.icon-ok').removeClass('icon-white')
    this

