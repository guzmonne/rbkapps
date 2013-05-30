class App.Models.FormHelper extends Backbone.Model
  urlRoot: '/api/form_helpers'

  url: ->
    u = '/api/form_helpers'
    if @id then u = u + "/#{@id}"
    return u

  defaults : ->
    column: null
    value: null

  destroy: ->
    $.ajax
      url: "/api/form_helpers/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'
