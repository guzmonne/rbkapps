class App.Views.UsersIndex extends Backbone.View
  template: JST['users/index']
  className: 'span12'
  name: 'IndexUsers'

  events:
    'click #fetch-users'  : 'fetchUsers'

  render: ->
    $(@el).html(@template())
    App.users.each(@appendUser)
    this

  appendUser: (model) =>
    view = new App.Views.User(model: model)
    App.pushToAppendedViews(view)
    @$('#users').append(view.render().el)
    this

  fetchUsers: (e) ->
    e.preventDefault()
    App.vent.trigger 'update:users'
    @$('#fetch-users').html('<i class="icon-load"></i>  Actualizando').addClass('loading')
    App.users.fetch success: =>
      @$('#fetch-users').html('Actualizar').removeClass('loading')
      App.users.each(@appendUser)
    this