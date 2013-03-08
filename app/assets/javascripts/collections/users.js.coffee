class App.Collections.Users extends Backbone.Collection
  model: App.Models.User
  urlRoot: 'api/users'
  url: '/api/users'

  getNameFromId: (id) ->
    name = null
    @each (model) =>
      if model.id == id
        name =  model.get('name')
    return name
