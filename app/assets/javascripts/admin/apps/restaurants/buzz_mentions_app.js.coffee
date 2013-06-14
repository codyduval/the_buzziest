@Admin.module "RestaurantsApp", (RestaurantsApp, App, Backbone, Marionette, $, _) ->

  class RestaurantsApp.Router extends Marionette.AppRouter
    appRoutes:
      "restaurants" : "listRestaurants"
  
  API =
    listRestaurants: ->
      RestaurantsApp.List.Controller.listRestaurants()

  App.addInitializer ->
    new RestaurantsApp.Router
      controller: API
