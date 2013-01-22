class App.Views.SessionCreate extends Backbone.View
  template: JST['session/create']

  events:
    'submit #create-session': 'createSession'

  render: ->
    $(@el).html(@template()).find('#create-session-modal').modal('show')
    $('#create-session-modal').modal('show')
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
        $('#create-session-modal').modal('toggle')
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
        @model.save({'id': data.id, 'remember_token': data.remember_token})
        Backbone.history.navigate('home', trigger = true)
      error: (user, status, response) ->
        alert "Email o Contraseña incorrecta. Verífique sus datos"
