class App.Collections.Invoices extends Backbone.Collection
  model: App.Models.Invoice
  url: '/api/invoices'