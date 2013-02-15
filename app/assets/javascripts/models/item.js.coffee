class App.Models.Item extends Backbone.Model
  urlRoot: '/api/items'

  defaults : ->
    code: null
    brand: null
    season: null
    entry: null