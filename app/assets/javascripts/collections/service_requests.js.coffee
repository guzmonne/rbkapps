class App.Collections.ServiceRequests extends Backbone.Collection
  model: App.Models.ServiceRequest
  url: '/api/service_requests'
  user_id: null

  initialize: ->
    @sortVar      = 'created_at'
    @sortMethod   = 'hTL'
    @sortVarType  = 'date'
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

  comparator: (service_requests) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return service_requests.get(@sortVar)
        else
          return -1 * service_requests.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return service_requests.get(@sortVar)
        else
          return String.fromCharCode.apply(String, _.map(service_requests.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if service_requests.get(@sortVar)? then return service_requests.get(@sortVar)
        else
          if service_requests.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(service_requests.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
