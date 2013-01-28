class App.Views.PurchaseRequestLineShow extends Backbone.View
  template: JST['purchase_request_line/show']
  tagName: 'tr'

  events:
    'click #remove-line': 'removeLine'

  render: ->
    $(@el).html(@template(model: @model))
    this

  removeLine: (e) ->
    e.preventDefault()
    @remove()
    App.vent.trigger 'removePurchaseRequestLine:success', @model