class App.Models.ServiceRequest extends Backbone.Model

  url: ->
    u = '/api/service_requests'
    if @id then u = u + "/#{@id}"
    return u