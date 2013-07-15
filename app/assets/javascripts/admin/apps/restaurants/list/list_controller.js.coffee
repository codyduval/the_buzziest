@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      restaurants = App.request "restaurant:entities"
      subnavs = App.request "restaurant:subnavs"

      App.execute "when:fetched", restaurants, =>
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView subnavs, restaurants
          @showPanel()
          @showRestaurants restaurants

        App.mainRegion.show @layout

    showPanel: ->
      restaurantsPanelView = @getPanelView()
      @layout.restaurantsPanelRegion.show restaurantsPanelView

      restaurantsPanelView.on "panel:new:restaurants:link:clicked", =>
        console.log("new link clicked")

    showSubNavView: (subnavs, restaurants) ->
      subNavView = @getSubNavView subnavs
      subNavView.on "new:restaurants:button:clicked", =>
        @showNewRegion()

      subNavView.on "filter:age:slider:clicked", =>
        @showAgeSliderValue(restaurants)

      @layout.restaurants_subnavRegion.show subNavView

    showAgeSliderValue: (restaurants) ->
      agevalue = $('#test-slider3').slider('getValue')
      ageValueArray = agevalue.val()
      ageValueLow = ageValueArray[0]
      ageValueHigh = ageValueArray[1]
      console.log(agevalue.val())
      console.log(restaurants)
      filtered_restaurants = restaurants.filter((restaurant) ->
        age = restaurant.get("age_in_days")
        if ((age > ageValueLow) && (age < ageValueHigh)) then true
      )
      console.log(filtered_restaurants)

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
