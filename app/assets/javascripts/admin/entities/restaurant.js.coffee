@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Restaurant extends Entities.Model

  class Entities.RestaurantsCollection extends Entities.Collection
    model: Entities.Restaurant
    url: -> Routes.restaurants_path()

  API =
    getRestaurantEntities: (cb) ->
      restaurants = new Entities.RestaurantsCollection
      restaurants.fetch
        #don't need reset: true now b/c using call back to wait to render
        reset: true
        success: ->
          cb restaurants

  App.reqres.setHandler "restaurant:entities", (cb) ->
    API.getRestaurantEntities cb
