class App.Models.PurchaseRequest extends Backbone.Model

  url: ->
    u = '/api/purchase_requests'
    if @id then u = u + "/#{@id}"
    return u

  initialize: ->
    @dateHelper = new App.Mixins.Date()
    @lines = new App.Collections.PurchaseRequestLines([], {purchase_request_id: @id})

  defaults: ->
    id          : null
    user_id     : null
    deliver_at  : null
    sector      : null
    use         : null
    state       : null
    detail      : null
    approved_by : null

  saveModel: (attributes, options) ->
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
