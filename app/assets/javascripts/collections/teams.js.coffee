class App.Collections.Teams extends Backbone.Collection
  model: App.Models.Team
  url: 'api/teams'

  getNameFromId: (id) ->
    name = null
    @each (model) =>
      if model.id == id
        name =  model.get('name')
    return name