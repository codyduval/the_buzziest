@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Restaurants extends App.Entities.Model
    urlRoot: -> Routes.restaurants_path()

  class Entities.RestaurantsCollection extends App.Entities.Collection
    model: Entities.Restaurants
    url: -> Routes.restaurants_path()

  class Entities.RestaurantsSubNav extends App.Entities.Collection
    model: Entities.Restaurants

  API =
    getRestaurantEntities: (cb) ->
      restaurants = new Entities.RestaurantsCollection
      restaurants.fetch
        #don't need reset: true now b/c using call back to wait to render
        reset: true
        success: ->
          cb restaurants

    getSubNavs: ->
      new Entities.RestaurantsSubNav [
        { name: "New York" }
        { name: "San Francisco" }
        { name: "Los Angeles" }
        { name: "All" }
      ]

    newRestaurant: ->
      RestaurantsApp.New.Controller.newRestaurant()

    getRestaurant: (id) ->
      restaurant = new Entities.Restaurants
        id: id
      restaurant.fetch()
      restaurant

  App.reqres.setHandler "restaurant:entities", (cb) ->
    API.getRestaurantEntities cb

  App.reqres.setHandler "restaurants:entity", (id) ->
    API.getRestaurant id

  App.reqres.setHandler "restaurant:subnavs", ->
    API.getSubNavs()

  App.reqres.setHandler "new:restaurants:restaurant:view", ->
    API.newRestaurant()
