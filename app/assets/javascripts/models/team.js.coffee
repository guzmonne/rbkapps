class App.Models.Team extends Backbone.Model
  url: ->
    "api/teams/#{@id}"

  defaults: ->
    id: null
    name: null
    supervisor_id: null
    director_id: null