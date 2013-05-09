class App.Models.PurchaseOrder extends Backbone.Model

  url: ->
    u = '/api/purchase_orders'
    if @id then u = u + "/#{@id}"
    return u

  initialize: ->
    @quotation = App.Models.Quotation()