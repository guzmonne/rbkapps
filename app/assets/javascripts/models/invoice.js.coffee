class App.Models.Invoice extends Backbone.Model
  urlRoot: '/api/invoices'

  defaults:  ->
    invoice_number: null
    fob_total_cost: null
    total_units: null