@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.User extends Entities.Model

  class Entities.UsersCollection extends Entities.Collection
    model: Entities.User

  API =
    setCurrentUser: (currentUser) ->
      new Entities.User currentUser

  App.reqres.setHandler "set:current:user", (currentUser) ->
    API.setCurrentUser currentUser
