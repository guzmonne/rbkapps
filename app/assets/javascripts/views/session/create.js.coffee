class App.Views.SessionCreate extends Backbone.View
  template: JST['session/create']
  name: "SessionCreate"

  events:
    'submit #create-session': 'createSession'

  render: ->
    $(@el).html(@template())
    this

  createSession: (e) ->
    e.preventDefault()
    attributes =
      email:    $('#email').val()
      password: $('#password').val()
    $.ajax
      url: '/api/sessions'
      async: 'false'
      data: attributes
      type: 'POST'
      dataType: 'json'
      success: (data) =>
        App.session.save({'id': data.id, 'remember_token': data.remember_token})
        App.user = App.users.get(data.id)
        Backbone.history.navigate('home', trigger = true)
      error: (user, status, response) ->
        alert "Email o Contraseña incorrecta. Verífique sus datos"
