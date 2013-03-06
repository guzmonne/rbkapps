class App.Collections.Deliveries extends Backbone.Collection
  model: App.Models.Delivery
  url: '/api/deliveries'

  initialize: ->
    @sortVar      = 'id'
    @sortMethod   = 'lTH'
    @sortVarType  = 'integer'

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