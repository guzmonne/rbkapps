class App.Collections.PurchaseRequestLines extends Backbone.Collection
  purchase_request_id: null
  model: App.Models.PurchaseOrderLine

  url: ->
    u = "api/purchase_request_lines"
    unless @purchase_request_id ==  null
      u = "#{u}/#{@id}"
    u

  fetch: (options) ->
    if @purchase_request_id == null then return "La coleccion no tiene definidio un purchase_request_id"
    $.ajax
      url: "/api/purchase_request_lines"
      type: 'GET'
      async: false
      dataType: 'json'
      data: {purchase_request_id: @purchase_request_id}
      success: (data) =>
        if data.length > 1
          for dataSet in data
            model = new App.Models.PurchaseRequestLine
            model.set('description', dataSet.description)
            model.set('unit', dataSet.unit)
            model.set('quantity', dataSet.quantity)
            @add(model)
          options.success(@)
        else
          model = new App.Models.PurchaseRequestLine
          model.set('description', data.description)
          model.set('unit', data.unit)
          model.set('quantity', data.quantity)
          @add(model)
          options.success(@)
      error: (data, status, response) ->
        console.log data, status, response