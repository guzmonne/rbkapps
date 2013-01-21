class App.Models.User extends Backbone.Model
  url: ->
    "api/users/#{@id}"

  defaults: ->
    id: null
    name: null
    email: null
    position: null
    phone: null
    cellphone: null
    location: null
    team: null