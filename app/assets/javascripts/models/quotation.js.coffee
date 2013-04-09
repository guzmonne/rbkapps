class App.Models.Quotation extends Backbone.Model
  urlRoot: '/api/quotations'

  url: ->
    u = '/api/quotations'
    if @id then u = u + "/#{@id}"
    return u

  defaults: ->
    supplier_id       : null
    method_of_payment : null
    total_net         : null
    iva               : null

  destroy: ->
    $.ajax
      url: "/api/quotations/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'