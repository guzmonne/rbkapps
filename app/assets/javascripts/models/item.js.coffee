class App.Models.Item extends Backbone.Model
  urlRoot: '/api/items'

  url: ->
    u = '/api/items'
    if @id then u = u + "/#{@id}"
    return u

  defaults : ->
    code: null
    brand: null
    season: null
    entry: null