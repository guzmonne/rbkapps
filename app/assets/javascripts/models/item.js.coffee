class App.Models.Item extends Backbone.Model
  urlRoot: '/api/items'

  defaults : ->
    name: null
    brand: null
    season: null
    entry: null