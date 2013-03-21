class App.Models.Delivery extends Backbone.Model
  urlRoot: '/api/deliveries'

  initialize: (model) ->
    @invoices = new App.Collections.Invoices()

  defaults:  ->
    courier               : null
    dispatch              : null
    guide                 : null
    guide2                : null
    guide3                : null
    cargo_cost            : null
    cargo_cost2           : null
    cargo_cost3           : null
    dispatch_cost         : null
    dua_cost              : null
    supplier              : null
    origin                : null
    origin_date           : null
    arrival_date          : null
    delivery_date         : null
    status                : null
    invoice_delivery_date : null
    doc_courier_date      : null

  fetchSubCollections: (options) ->
    if @invoices.length == 0
      @invoices.fetch data: {delivery_id: @id}, success: =>
        if @items.length == 0
          @items.fetch data: {delivery_id: @id}, success: =>
            if options.success then return options.success(@invoices, @items)
            return this
        else
          if options.success then return options.success(@invoices, @items)
          return this
    else
      if @items.length == 0
        @items.fetch data: {delivery_id: @id}, success: =>
          if options.success then return options.success(@invoices, @items)
          return this
      else
        if options.success then return options.success(@invoices, @items)
        return this
