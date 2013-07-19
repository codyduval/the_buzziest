@Admin.module "RestaurantsApp", (RestaurantsApp, App, Backbone, Marionette, $, _) ->

  class RestaurantsApp.Router extends Marionette.AppRouter
    appRoutes:
      "restaurants/:id/edit" : "editRestaurant"
      "restaurants" : "listRestaurants"
  
  API =
    listRestaurants: ->
      RestaurantsApp.List.Controller.listRestaurants()

    filterRestaurants: (sliders) ->
      RestaurantsApp.List.Controller.filterRestaurants(sliders)

    updateFilterValue: (slider) ->
      RestaurantsApp.List.Controller.updateFilterValue slider

    newRestaurant: ->
      RestaurantsApp.New.Controller.newRestaurant()

    editRestaurant: (id, restaurant) ->
      RestaurantsApp.Edit.Controller.editRestaurant id, restaurant

  App.reqres.setHandler "new:restaurant:restaurant:view", ->
    API.newRestaurant()

  App.vent.on "restaurants:restaurant:clicked", (restaurant) ->
    App.navigate Routes.edit_restaurant_path(restaurant.id)
    API.editRestaurant restaurant.id, restaurant

  App.vent.on "sliders:slider:clicked",(sliders) ->
    API.filterRestaurants(sliders)

  App.addInitializer ->
    new RestaurantsApp.Router
      controller: API
