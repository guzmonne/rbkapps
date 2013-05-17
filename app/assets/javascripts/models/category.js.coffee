class App.Models.Category extends Backbone.Model
  url: ->
    u = "/api/categories"
    if @id? then u = "#{u}/#{@id}"
    return u

  destroy: (level) ->
    $.ajax
      url: @url()
      data: {id: @id, level: level}
      type: 'DELETE'
      dataType: 'json'