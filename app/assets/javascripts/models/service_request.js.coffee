class App.Models.ServiceRequest extends Backbone.Model

  initialize: ->
    if @id
      model = App.categories.get(@get('category_id'))
      @set('category1', model.get('category1'))
      @set('category2', model.get('category2'))
      @set('category3', model.get('category3'))

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
