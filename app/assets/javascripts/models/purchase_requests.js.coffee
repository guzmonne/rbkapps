class App.Models.PurchaseRequest extends Backbone.Model
  url: ->
    "api/purchase_requests/#{@id}"

  defaults: ->

