class App.Collections.Items extends Backbone.Collection
  model: App.Models.Item
  urlRoot: 'api/items'
  url: '/api/items'

  initialize: ->
    @sortVar      = 'code'
    @sortMethod   = 'lTH'
    @sortVarType  = 'string'
    @perGroup     = 101
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

  comparator: (item) ->
    switch @sortVarType
      when 'integer'
        if @sortMethod == "lTH"
          return item.get(@sortVar)
        else
          return -1 * item.get(@sortVar)
      when 'string'
        if @sortMethod == "lTH"
          return item.get(@sortVar)
        else
          if item.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(item.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))
      when 'date'
        if @sortMethod == "lTH"
          if item.get(@sortVar)? then return item.get(@sortVar)
        else
          if item.get(@sortVar)?
            return String.fromCharCode.apply(String, _.map(item.get(@sortVar).split(""), (c)  => return 0xffff - c.charCodeAt() ))

  page: (page_number) ->
    @currentPage = page_number
    i = ( @perGroup * page_number ) - ( @perGroup )
    j = ( @perGroup * page_number ) - 1
    collection = new App.Collections.Items()
    collection.setSortVariables(@sortVarType, @sortVar, @sortMethod)
    for model in this when i<j
      collection.add(@models[i])
      i++
      return collection if i > @length
    return collection

  setSortVariables: (type, sortVar, method) ->
    @sortVarType = type
    @sortVar     = sortVar
    @sortMethod  = method