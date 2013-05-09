class App.Collections.Categories extends Backbone.Collection
  model: App.Models.Category
  url: '/api/categories'

  initialize: ->
    @sortVar = 'category1'

  comparator: (model) ->
    return model.get(@sortVar)

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
