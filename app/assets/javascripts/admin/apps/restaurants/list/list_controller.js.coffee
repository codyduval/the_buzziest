@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      App.request "restaurant:entities", (restaurants) =>

        @layout = @getLayoutView()

        @layout.on "show", =>
          @showPanel restaurants
          @showRestaurants restaurants

        App.mainRegion.show @layout
   
    showPanel: (restaurants) ->
      restaurantsPanelView = @getPanelView restaurants
      @layout.restaurantsPanelRegion.show restaurantsPanelView

    showRestaurants: (restaurants) ->
      restaurantsListView = @getRestaurantsView restaurants
      @layout.restaurantsListRegion.show restaurantsListView

    getPanelView: (restaurants) ->
      new List.Panel
        collection: restaurants

    getRestaurantsView: (restaurants) ->
      new List.Restaurants
        collection: restaurants

    getLayoutView: ->
      new List.Layout
