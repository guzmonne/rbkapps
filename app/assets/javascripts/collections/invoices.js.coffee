class App.Collections.Invoices extends Backbone.Collection
  model: App.Models.Invoice
  url: '/api/invoices'

  initialize: ->
    @sortVar      = 'id'
    @sortMethod   = 'lTH'
    @sortVarType  = 'integer'

  comparator: (invoice) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return invoice.get(@sortVar)
        else
          return -1 * invoice.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return invoice.get(@sortVar)
        else
          return String.fromCharCode.apply(String, _.map(invoice.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if invoice.get(@sortVar)? then return invoice.get(@sortVar)
        else
          if invoice.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(invoice.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))