class App.Models.PurchaseRequest extends Backbone.Model
  url: ->
    "api/purchase_requests/#{@id}"

  defaults: ->
    id: null
    user_id: null
    deliver_at: null
    sector:  null
    use: null
    state: null


