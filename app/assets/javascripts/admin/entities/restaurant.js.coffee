@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Restaurant extends Entities.Model

  class Entities.RestaurantsCollection extends Entities.Collection
    model: Entities.Restaurant
    url: -> Routes.restaurants_path()

  class Entities.RestaurantsSubNav extends Entities.Collection
    model: Entities.Restaurant

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

  App.reqres.setHandler "restaurant:entities", (cb) ->
    API.getRestaurantEntities cb

  App.reqres.setHandler "restaurant:subnavs", ->
    API.getSubNavs()

  App.reqres.setHandler "new:restaurants:restaurant:view", ->
    API.newRestaurant()
