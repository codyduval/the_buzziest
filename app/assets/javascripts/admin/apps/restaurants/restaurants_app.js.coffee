@Admin.module "RestaurantsApp", (RestaurantsApp, App, Backbone, Marionette, $, _) ->

  class RestaurantsApp.Router extends Marionette.AppRouter
    appRoutes:
      "restaurants" : "listRestaurants"
  
  API =
    listRestaurants: ->
      RestaurantsApp.List.Controller.listRestaurants()

    newRestaurant: ->
      RestaurantsApp.New.Controller.newRestaurant()

  App.reqres.setHandler "new:restaurants:restaurant:view", ->
    API.newRestaurant()

  App.addInitializer ->
    new RestaurantsApp.Router
      controller: API
