class App.Models.Supplier extends Backbone.Model
  urlRoot: '/api/suppliers'

  url: ->
    u = '/api/suppliers'
    if @id then u = u + "/#{@id}"
    return u

  destroy: ->
    $.ajax
      url: "/api/suppliers/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'