class App.Views.Nav extends Backbone.View
  template: JST['layout/nav']
  tagName: "nav"
  className: "navbar-inner"

  render: ->
    $(@el).html(@template(user: @model))
    this