@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Nav extends Entities.Model

  class Entities.NavCollection extends Entities.Collection
    model: Entities.Nav

  API =
    getNavs: ->
      new Entities.NavCollection [
        { name: "Dashboard", url: "dashboard" }
        { name: "Buzz Mentions", url:Routes.buzz_mentions_path() }
        { name: "Buzz Posts", url: "buzz_posts"}
        { name: "Restaurants", url:Routes.restaurants_path()}
      ]

  App.reqres.setHandler "nav:entities", ->
    API.getNavs()
