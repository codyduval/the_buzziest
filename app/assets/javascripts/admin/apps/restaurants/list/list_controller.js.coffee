@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      restaurants = App.request "restaurant:entities"
      subnavs = App.request "restaurant:subnavs"
      sliders = App.request "restaurant:sliders"

      App.execute "when:fetched", restaurants, =>
        filterParams = App.request "restaurant:filterValues", restaurants
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView(subnavs)
          @showFilterSliders(sliders, filterParams)
          @showPanel()
          #@showRestaurants restaurants
          @showFilteredListView(restaurants, filterParams)

        App.mainRegion.show @layout

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

    showFilterSliders: (sliders, filterParams) ->
      console.log(sliders)
      filterSlidersView = @getFilterSlidersView(sliders)
     
      filterSlidersView.on "filter:mentions:slider:clicked", =>
        sliderValue = $('#mentions-slider').slider('getValue')
        sliderValueText = sliderValue.val()
        sliderValueArray = sliderValueText.split(',')
        filterParams.mentionLow = sliderValueArray[0]
        filterParams.mentionHigh = sliderValueArray[1]
        console.log(filterParams)
        @showFilteredListView(restaurants, filterParams)

      filterSlidersView.on "filter:age:slider:clicked", =>
        sliderValue = $('#age-slider').slider('getValue')
        sliderValueText = sliderValue.val()
        sliderValueArray = sliderValueText.split(',')
        filterParams.ageLow = sliderValueArray[0]
        filterParams.ageHigh = sliderValueArray[1]
        console.log(filterParams)
        @showFilteredListView(restaurants, filterParams)
        
      filterSlidersView.on "filter:score:slider:clicked", =>
        sliderValue = $('#score-slider').slider('getValue')
        sliderValueText = sliderValue.val()
        sliderValueArray = sliderValueText.split(',')
        filterParams.scoreLow = sliderValueArray[0]
        filterParams.scoreHigh = sliderValueArray[1]
        console.log(filterParams)
        @showFilteredListView(restaurants, filterParams)

      @layout.restaurantsSlidersRegion.show filterSlidersView

    showFilteredListView: (restaurants, filterParams) ->
      filteredListView = @getFilteredListView(restaurants, filterParams)

      @layout.restaurantsListRegion.show filteredListView

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

    getFilterSlidersView: (sliders) ->
      new List.Sliders
        collection: sliders

    getFilteredListView: (restaurants, filterParams) ->
      filtered_restaurants = App.request "restaurants:filtered:entities", restaurants, filterParams

      new List.Restaurants
        collection: filtered_restaurants

    getLayoutView: ->
      new List.Layout
