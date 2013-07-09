@Admin.module "RestaurantsApp.New", (New, App, Backbone, Marionette, $, _) ->

  New.Controller =

    newRestaurant: ->
      newView = @getNewView()

      newView

    getNewView: ->
      new New.Restaurant
