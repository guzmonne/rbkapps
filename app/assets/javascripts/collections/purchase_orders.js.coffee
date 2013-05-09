class App.Collections.PurchaseOrders extends Backbone.Collection
  model: App.Models.PurchaseOrder
  url: '/api/purchase_orders'
  user_id: null

  initialize: ->
    @sortVar      = 'created_at'
    @sortMethod   = 'hTL'
    @sortVarType  = 'date'
    @perGroup     = 100
    @currentPage  = 1

  comparator: (purchase_orders) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return purchase_orders.get(@sortVar)
        else
          return -1 * purchase_orders.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return purchase_orders.get(@sortVar)
        else
          return String.fromCharCode.apply(String, _.map(purchase_orders.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if purchase_orders.get(@sortVar)? then return purchase_orders.get(@sortVar)
        else
          if purchase_orders.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(purchase_orders.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
