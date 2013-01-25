class App.Models.PurchaseRequestLine extends Backbone.Model
  url: ->
    "api/purchase_request_lines/#{@id}"

  defaults: ->
    id: null
    description: null
    unit: null
    quantity:  null