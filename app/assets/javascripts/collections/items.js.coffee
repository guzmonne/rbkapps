class App.Collections.Items extends Backbone.Collection
  model: App.Models.Item
  urlRoot: 'api/items'
  url: '/api/items'

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