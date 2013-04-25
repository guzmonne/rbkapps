class App.Views.SessionCreate extends Backbone.View
  template: JST['sessions/create']
  name: "SessionCreate"

  events:
    'submit #create-session': 'createSession'

  render: ->
    #if App.session.load().authenticated()
    #  return @goToHome()
    $(@el).html(@template())
    this

  goToHome: ->
    App.start()
    $('body').css('background-color', 'white')
    Backbone.history.navigate('home', trigger = true)
    this

  createSession: (e) ->
    e.preventDefault() if e?
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
        App.user.set(data)
        App.start()
        $('body').css('background-color', 'white')
        Backbone.history.navigate('home', trigger = true)
      error: (user, status, response) ->
        alert "Email o Contraseña incorrecta. Verífique sus datos"
