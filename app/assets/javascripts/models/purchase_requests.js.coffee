class App.Models.PurchaseRequest extends Backbone.Model

  initialize: ->
    @dateHelper = new App.Mixins.Date()
    @lines = new App.Collections.PurchaseRequestLines([], {purchase_request_id: @id})

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

  save: (attributes, options) ->
    $.ajax
      url: "/api/purchase_requests"
      data: attributes
      type: 'POST'
      async: false
      dataType: 'json'
      success: (data) =>
        @set(data)
        options.success(data)
      error: (data, status, response) ->
        alert data, status, response

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
