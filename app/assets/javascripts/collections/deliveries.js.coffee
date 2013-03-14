class App.Collections.Deliveries extends Backbone.Collection
  model: App.Models.Delivery
  url: '/api/deliveries'

  initialize: ->
    @sortVar      = 'id'
    @sortMethod   = 'hTL'
    @sortVarType  = 'integer'
    @perGroup     = 100
    @currentPage  = 1

  pluckDistinct: (attribute, attributes=null) ->
    if attributes == null
      array = this.pluck(attribute)
    else
      plucks = this.where(attributes)
      array = []
      for element in plucks
        array.push(element.get(attribute))
    output = {}
    output[array[key]] = array[key] for key in [0...array.length]
    value for key, value of output

  comparator: (delivery) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return delivery.get(@sortVar)
        else
          return -1 * delivery.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return delivery.get(@sortVar)
        else
          return String.fromCharCode.apply(String, _.map(delivery.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if delivery.get(@sortVar)? then return delivery.get(@sortVar)
        else
          if delivery.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(delivery.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))

  page: (page_number) ->
    @currentPage = page_number
    i = ( @perGroup * page_number ) - ( @perGroup )
    j = ( @perGroup * page_number )
    collection = new App.Collections.Deliveries()
    for model in this when i<j
      collection.add(@models[i])
      i++
      return collection if i > @length
    collection.sort()
    return collection

  setSortVariables: (type, sortVar, method) ->
    @sortVarType = type
    @sortVar     = sortVar
    @sortMethod  = method
