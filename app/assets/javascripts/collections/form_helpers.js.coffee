class App.Collections.FormHelpers extends Backbone.Collection
  model: App.Models.FormHelper
  urlRoot: 'api/form_helpers'
  url: '/api/form_helpers'

  addHelpers: (objects) ->
    for object in objects
      if @objextExists(object) == false
        attributes =
          column: Object.keys(object)[0]
          value : object[Object.keys(object)[0]]
        model = new App.Models.FormHelper
        model.save(attributes)
        @add(model)

  objextExists: (object) ->
    key = Object.keys(object)[0]
    return true if object[key] == null
    collection = @where({column: key})
    for model in collection
      return true if model.get('value') == object[key]
    return false

  comparator: (model) ->
    return model.get('value')