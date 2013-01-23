class App.Views.UserCreate extends Backbone.View
  template: JST['users/create']
  name: 'UserCreate'
  className: 'span12'
  model = new App.Models.User()

  render: ->
    render: ->
    $(@el).html(@template(user: @model))
    this

