class App.Models.Category extends Backbone.Model
  url: ->
    u = "/api/categories"
    if @id? then u = "#{u}/#{@id}"
    return u