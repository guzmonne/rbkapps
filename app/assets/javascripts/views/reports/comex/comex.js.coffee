class App.Views.ComexReports extends Backbone.View
  template: JST['reports/comex/main']
  costEntry: JST['reports/comex/costs-entry']
  costEntryItem: JST['reports/comex/costs-entry-item']
  costEntryDelivery: JST['reports/comex/costs-entry-delivery']
  costEntryInvoice: JST['reports/comex/costs-entry-invoices']

  events:
    'click  li'              : 'setReport'
    'click #run-report'      : 'getData'

  initialize: ->
    @report = null
    @init   = 0
    @listenTo App.d_i,        "reset", => @loadingBar()
    @listenTo App.items,      "reset", => @loadingBar()
    @listenTo App.deliveries, "reset", => @loadingBar()
    @listenTo App.invoices,   "reset", => @loadingBar()

  render: ->
    $(@el).html(@template())
    this

  setReport: (e) ->
    e.preventDefault()
    console.log e.currentTarget.firstChild.dataset["report"]
    $('#report-name').fadeOut 'slow', ->
      $('#report-name').text(e.currentTarget.textContent).fadeIn()
    @report = e.currentTarget.firstChild.dataset["report"]
    this

  runReport: (e) ->
    e.preventDefault() if e?
    entries = App.items.pluckDistinct('entry')
    entry_index = 0
    item_index  = 0
    delivery_index = 0
    for entry in entries
      entry_index = entry_index + 1
      @$('#table-report').append(@costEntry(entry: entry, index: entry_index))
      items = App.items.where entry: entry
      for item in items
        item_index = item_index + 1
        @$('#entry-' + entry_index).append(@costEntryItem(item: item, index: item_index))
        deliveries = []
        _.map App.d_i.where({item_id: item.id}), (model) => return deliveries.push App.deliveries.get(model.get('delivery_id'))
        for delivery in deliveries
          delivery_index = delivery_index + 1
          if delivery?
            @$('#item-' + item_index).append(@costEntryDelivery(delivery: delivery, index: delivery_index))
            invoices = []
            invoices = App.invoices.where delivery_id: delivery.id
            for invoice in invoices
              if invoice?
                console.log delivery, invoices
                @$('#delivery-' + delivery_index).append(@costEntryInvoice(invoice: invoice))
    @loadingBar()
    this

  custom: ->
    deliveries = []
    _.map App.d_i.where({item_id: item.id}), (model) => return deliveries.push App.deliveries.get(model.get('delivery_id'))
    for delivery in deliveries
      if delivery?
        @$('.deliveries-table').append(@costEntryDelivery(delivery: delivery))
        invoices = []
        invoices = App.invoices.where delivery_id: delivery.id
        for invoice in invoices
          if invoice?
            console.log delivery, invoices
            @$('.invoices-table').append(@costEntryInvoice(invoice: invoice))

  getData: (e) ->
    e.preventDefault()
    App.d_i.fetch()
    App.items.fetch()
    App.deliveries.fetch()
    App.invoices.fetch()
    @loadingBar()

  loadingBar: ->
    $('.loading-bar').show() if @init == 0
    $('.bar').css('width', (20) * @init + '%' )
    @init++
    @runReport() if @init == 5
    if @init == 6
      $('.loading-bar').hide()
      @init = 0



