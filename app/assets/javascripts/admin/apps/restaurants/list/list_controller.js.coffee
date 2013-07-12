@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      restaurants = App.request "restaurant:entities"
      subnavs = App.request "restaurant:subnavs"

      App.execute "when:fetched", restaurants, =>
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView subnavs
          @showPanel()
          @showRestaurants restaurants

        App.mainRegion.show @layout

    showPanel: ->
      restaurantsPanelView = @getPanelView()
      @layout.restaurantsPanelRegion.show restaurantsPanelView

    showSubNavView: (subnavs) ->
      subNavView = @getSubNavView subnavs
      subNavView.on "new:restaurants:button:clicked", =>
        @showNewRegion()

      @layout.restaurants_subnavRegion.show subNavView

    showRestaurants: (restaurants) ->
      restaurantsListView = @getRestaurantsView restaurants
      restaurantsListView.on "itemview:restaurants:restaurant:clicked",
      (child, restaurant) ->
        App.vent.trigger "restaurants:restaurant:clicked", restaurant

      @layout.restaurantsListRegion.show restaurantsListView

    showNewRegion: ->
      $("#new-restaurant").addClass("disabled").removeClass("btn-success")
      newRegion = App.request "new:restaurant:restaurant:view"

      newRegion.on "form:cancel:button:clicked", =>
        @layout.restaurants_newRegion.close()
        $("#new-restaurant").removeClass("disabled").addClass("btn-success")

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
