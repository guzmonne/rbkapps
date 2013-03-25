class App.Models.Note extends Backbone.Model
  urlRoot: '/api/notes'

  url: ->
    u = '/api/notes'
    if @id then u = u + "/#{@id}"
    return u

  destroy: ->
    $.ajax
      url: "/api/notes/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'