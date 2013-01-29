class App.Collections.PurchaseRequests extends Backbone.Collection
  model: App.Models.PurchaseOrder
  url: 'api/purchase_requests'
  user_id: null

  initialize: ->
    @purchaseRequestLines = new App.Collections.PurchaseRequestLines()

  fetch: (options) ->
    if @user_id == null then return "La coleccion no tiene definidio un user_id"
    $.ajax
      url: "/api/purchase_requests"
      type: 'GET'
      dataType: 'json'
      data: {user_id: @user_id}
      success: (data) =>
        if data.length > 1
          for dataSet in data
            model = new App.Models.PurchaseRequest
            model.set(dataSet)
            @add(model)
        else
          model = new App.Models.PurchaseRequest
          model.set(data)
          @add(model)
        options.success(@)
      error: (data, status, response) ->
        console.log data, status, response
