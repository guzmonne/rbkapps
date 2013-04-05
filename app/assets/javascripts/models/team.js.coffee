class App.Models.Team extends Backbone.Model
  url: ->
    u = "/api/teams"
    if @id? then u = "#{u}/#{@id}"
    return u

  defaults: ->
    id            : null
    name          : null
    supervisor_id : null
    director_id   : null
    cost_center   : null