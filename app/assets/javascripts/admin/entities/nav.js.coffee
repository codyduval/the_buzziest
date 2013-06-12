@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Nav extends Entities.Model

  class Entities.NavCollection extends Entities.Collection
    model: Entities.Nav

  API =
    getNavs: ->
      new Entities.NavCollection [
        { name: "Dashboard" }
        { name: "Buzz Mentions" }
        { name: "Buzz Posts" }
        { name: "Restaurants" }
      ]

  App.reqres.setHandler "nav:entities", ->
    API.getNavs()
