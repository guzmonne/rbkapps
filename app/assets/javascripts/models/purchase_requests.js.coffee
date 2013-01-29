class App.Models.PurchaseRequest extends Backbone.Model
  url: ->
    u = "api/purchase_request"
    if @id or @remember_token
      u = "#{u}#{@id}"
    u

  defaults: ->
    id: null
    user_id: null
    deliver_at: null
    sector:  null
    use: null
    state: null

  initialize: ->
    @dateHelper = new App.Mixins.Date()

  save: (attributes, options) ->
    $.ajax
      url: "/api/purchase_requests"
      data: attributes
      type: 'POST'
      dataType: 'json'
      success: (data) =>
        @set(data)
        options.success(data)
      error: (data, status, response) ->
        options.error(data, status, response)

  fetch: (options) ->
    $.ajax
      url: "/api/purchase_requests/#{@id}"
      type: 'GET'
      dataType: 'json'
      success: (data) =>
        @set(data)
        options.success(data)
      error: (data, status, response) ->
        options.error(data, status, response)
