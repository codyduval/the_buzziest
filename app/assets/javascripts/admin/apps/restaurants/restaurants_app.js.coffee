@Admin.module "RestaurantsApp", (RestaurantsApp, App, Backbone, Marionette, $, _) ->

  class RestaurantsApp.Router extends Marionette.AppRouter
    appRoutes:
      "restaurants/:id/edit" : "editRestaurant"
      "restaurants" : "listRestaurants"
  
  API =
    listRestaurants: ->
      RestaurantsApp.List.Controller.listRestaurants()

    listCityRestaurants:(restaurants) ->
      RestaurantsApp.List.Controller.listCityRestaurants(restaurants)

    newRestaurant: ->
      RestaurantsApp.New.Controller.newRestaurant()

    editRestaurant: (id, restaurant) ->
      RestaurantsApp.Edit.Controller.editRestaurant id, restaurant

  App.reqres.setHandler "new:restaurant:restaurant:view", ->
    API.newRestaurant()

  App.vent.on "restaurants:restaurant:clicked", (restaurant) ->
    App.navigate Routes.edit_restaurant_path(restaurant.id)
    API.editRestaurant restaurant.id, restaurant

  App.vent.on "subnavs:subnav:clicked", (restaurants) ->
    API.listCityRestaurants(restaurants) 

  App.vent.on "panel:panelnavs:clicked", (restaurants) ->
    API.listCityRestaurants(restaurants) 

  App.addInitializer ->
    new RestaurantsApp.Router
      controller: API
