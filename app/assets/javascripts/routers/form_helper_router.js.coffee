class App.Routers.FormHelper extends Backbone.Router

  routes:
    'form_helpers/edit'        : 'edit'

  edit: ->
    view = new App.Views.FormHelperEdit()
    App.setAndRenderContentViews([view])