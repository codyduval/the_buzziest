@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      App.request "restaurant:entities", (restaurants) =>

        subnavs = App.request "restaurant:subnavs"
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView subnavs
          @showPanel()
          @showRestaurants restaurants

        App.mainRegion.show @layout

    showPanel: ->
      restaurantsPanelView = @getPanelView()

      restaurantsPanelView.on "new:restaurants:button:clicked", =>
        @layout.restaurantsPanelRegion.close()
        @showNewRegion()

      @layout.restaurantsPanelRegion.show restaurantsPanelView

    showSubNavView: (subnavs) ->
      subNavView = @getSubNavView subnavs
      @layout.restaurants_subnavRegion.show subNavView

    showRestaurants: (restaurants) ->
      restaurantsListView = @getRestaurantsView restaurants
      @layout.restaurantsListRegion.show restaurantsListView

    showNewRegion: ->
      newRegion = App.request "new:restaurants:restaurant:view"

      newRegion.on "form:cancel:button:clicked", =>
        @layout.restaurants_newRegion.close()
        @showPanel()

      @layout.restaurants_newRegion.show newRegion

    getPanelView: ->
      new List.Panel

    getSubNavView: (subnavs) ->
      new List.RestaurantsSubNavs
        collection: subnavs

    getRestaurantsView: (restaurants) ->
      new List.Restaurants
        collection: restaurants

    getLayoutView: ->
      new List.Layout
