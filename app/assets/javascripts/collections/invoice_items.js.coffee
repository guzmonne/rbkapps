class App.Collections.InvoiceItems extends Backbone.Collection
  model: App.Models.InvoiceItem
  url: '/api/invoice_items'