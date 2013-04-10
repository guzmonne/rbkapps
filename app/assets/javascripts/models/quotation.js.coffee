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
    dollars           : false
    can_be_selected   : false

  destroy: ->
    $.ajax
      url: "/api/quotations/#{@id}"
      data: {id: @id}
      type: 'DELETE'
      dataType: 'json'