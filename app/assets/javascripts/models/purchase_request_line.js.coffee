class App.Models.PurchaseRequestLine extends Backbone.Model
  url: ->
    u = "api/purchase_request_lines"
    if @id or @remember_token
      u = "#{u}#{@id}"
    u

  defaults: ->
    id:                   null
    description:          null
    unit:                 null
    quantity:             null
    purchase_request_id:  null

  save: (options) ->
    info =
      purchase_request_line:
        description: @attributes.description
        purchase_request_id: @attributes.purchase_request_id
        quantity: @attributes.quantity
        unit: @attributes.unit
    $.ajax
      url: "/api/purchase_request_lines"
      data: info
      type: 'POST'
      dataType: 'json'
      success: (data) =>
        options.success(data)
      error: (data, status, response) ->
        options.error(data, status, response)