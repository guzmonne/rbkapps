class App.Collections.Suppliers extends Backbone.Collection
  model: App.Models.Supplier
  urlRoot: 'api/suppliers'
  url: '/api/suppliers'

  initialize: ->
    @sortVar      = 'entry'
    @sortMethod   = 'hTL'
    @sortVarType  = 'string'

  comparator: (supplier) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return supplier.get(@sortVar)
        else
          return -1 * supplier.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return supplier.get(@sortVar)
        else
          return String.fromCharCode.apply(String, _.map(supplier.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if supplier.get(@sortVar)? then return supplier.get(@sortVar)
        else
          if supplier.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(supplier.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))

  setSortVariables: (type, sortVar, method) ->
    @sortVarType = type
    @sortVar     = sortVar
    @sortMethod  = method