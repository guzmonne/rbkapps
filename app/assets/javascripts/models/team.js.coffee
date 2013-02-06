class App.Models.Team extends Backbone.Model
  url: ->
    "api/teams/#{@id}"

  defaults: ->
    id: null
    name: null
    supervisor_id: null
    director_id: null

  save: (attributes, options) ->
    $.ajax
      url: "/api/teams"
      data: attributes
      type: 'POST'
      dataType: 'json'
      success: (data, status, response) ->
        options.success(data, status, response)
      error: (data, status, response) ->
        options.error(data, status, response)