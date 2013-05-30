class App.Models.ServiceRequest extends Backbone.Model

  url: ->
    u = '/api/service_requests'
    if @id then u = u + "/#{@id}"
    return u

  destroy: ->
    $.ajax
      url: "/api/service_requests/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'

  status: ->
    return @get('status')