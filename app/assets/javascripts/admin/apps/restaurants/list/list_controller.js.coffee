@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      allRestaurants = App.request "restaurant:entities"
      subnavs = App.request "restaurant:subnavs"
      sliders = App.request "restaurant:sliders"

      App.execute "when:fetched", allRestaurants, =>
        restaurants = App.request "restaurant:filter:entities", allRestaurants
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView(subnavs)
          @showFilterSliders(sliders)
          @showPanel()
          @showRestaurants(restaurants, sliders)

        App.mainRegion.show @layout
    
    updateFilterValue: (slider) ->
      sliderSelector = slider.get('cssID')
      sliderValue = $("#"+ sliderSelector).slider('getValue')
      sliderValueText = sliderValue.val()
      sliderValueArray = sliderValueText.split(',')
      slider.set({minValue: sliderValueArray[0], maxValue: sliderValueArray[1]})
      console.log('updateFilterValue is', slider)
      @showRestaurants()

    showPanel: ->
      restaurantsPanelView = @getPanelView()
      @layout.restaurantsPanelRegion.show restaurantsPanelView

      restaurantsPanelView.on "panel:new:restaurants:link:clicked", =>
        console.log("new link clicked")

    showSubNavView: (subnavs) ->
      subNavView = @getSubNavView subnavs
      subNavView.on "new:restaurants:button:clicked", =>
        @showNewRegion()

      @layout.restaurants_subnavRegion.show subNavView

    showFilterSliders: (sliders) ->
      filterSlidersView = @getFilterSlidersView(sliders)
     
      filterSlidersView.on "itemview:sliders:slider:clicked",
      (child, slider) ->
        sliderSelector = slider.get('cssID')
        sliderValue = $("#"+ sliderSelector).slider('getValue')
        sliderValueText = sliderValue.val()
        sliderValueArray = sliderValueText.split(',')
        slider.set({minValue: sliderValueArray[0], maxValue: sliderValueArray[1]})
        console.log('updateFilterValue is', slider)
        console.log('all sliders', sliders)
        App.vent.trigger "sliders:slider:clicked", sliders

      @layout.restaurantsSlidersRegion.show filterSlidersView

    filterRestaurants: (sliders) ->
      @showRestaurants(restaurants, sliders)

    showRestaurants: (restaurants, sliders) ->
      restaurants.filterBy(sliders)
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

    getFilterSlidersView: (sliders) ->
      new List.Sliders
        collection: sliders

    getFilteredListView: (restaurants, sliders) ->
      console.log(sliders)
      filtered_restaurants = App.request "restaurants:filtered:entities", restaurants, sliders

      new List.Restaurants
        collection: filtered_restaurants

    getLayoutView: ->
      new List.Layout
