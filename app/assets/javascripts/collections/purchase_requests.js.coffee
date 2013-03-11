class App.Collections.PurchaseRequests extends Backbone.Collection
  model: App.Models.PurchaseRequest
  url: '/api/purchase_requests'
  user_id: null

  comparator: (purchase_request) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return purchase_request.get(@sortVar)
        else
          return -1 * purchase_request.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return purchase_request.get(@sortVar)
        else
          return String.fromCharCode.apply(String, _.map(purchase_request.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if purchase_request.get(@sortVar)? then return purchase_request.get(@sortVar)
        else
          if purchase_request.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(purchase_request.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
