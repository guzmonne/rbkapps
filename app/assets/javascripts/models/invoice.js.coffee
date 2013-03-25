class App.Models.Invoice extends Backbone.Model
  urlRoot: '/api/invoices'

  initialize: ->
    @invoice_items = new App.Collections.InvoiceItems

  defaults:  ->
    invoice_number: null
    fob_total_cost: null
    total_units: null
    delivery_id: null

  destroy: ->
    $.ajax
      url: "/api/invoices/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'