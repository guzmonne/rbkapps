class App.Views.UserShow extends Backbone.View
  template: JST['users/show']
  name: 'UserShow'
  className: 'span12'

  events:
    'click #update-password': 'changePassword'
    'click #submit-change-password': 'submitChangePassword'

  initialize: ->
    @model.set('team', App.teams.getNameFromId(@model.get('team_id')))

  render: ->
    $(@el).html(@template(user: @model))
    if App.user.maintenance() or App.user.admin()
      view = new App.Views.ServiceRequestGraph()
      App.pushToAppendedViews(view)
      @$('#panel_container').prepend(view.render().el)
      @$('#panel_container').prepend(view.render2().el)
    this

  changePassword: (e) ->
    e.preventDefault()
    $('#change-password-modal').modal('toggle')
    this

  submitChangePassword: (e) =>
    e.preventDefault()
    credentials =
      password: $('#password').val()
      confirm_password: $('#confirm-password').val()
    @model.changePasword(credentials)