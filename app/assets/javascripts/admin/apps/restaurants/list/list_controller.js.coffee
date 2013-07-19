@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listRestaurants: ->
      allRestaurants = App.request "restaurant:entities"
      subnavs = App.request "restaurant:subnavs"

      App.execute "when:fetched", allRestaurants, =>
        restaurants = App.request "restaurant:filter:entities", allRestaurants
        sliders = App.request "restaurant:sliders", allRestaurants
        panelnavs = App.request "restaurant:panelnavs", allRestaurants
        console.log("panelnavs", panelnavs)
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView(restaurants, subnavs)
          @showFilterSliders(restaurants, sliders)
          @showPanel(restaurants, panelnavs)
          @showRestaurants(restaurants, sliders)

        App.mainRegion.show @layout
    
    showPanel: (restaurants, panelnavs) ->
      restaurantsPanelView = @getPanelView(panelnavs)
      @layout.restaurantsPanelRegion.show restaurantsPanelView

      restaurantsPanelView.on "itemview:panel:panelnavs:clicked",
      (child, panelnav) ->
        restaurants.panelSortBy(panelnav)
        console.log("panelnav clicked",panelnav)

    showSubNavView: (restaurants, subnavs) ->
      subNavView = @getSubNavView subnavs
      subNavView.on "new:restaurants:button:clicked", =>
        @showNewRegion()

      subNavView.on "itemview:subnavs:subnav:clicked",
      (child, subnav) ->
        restaurants.subNavSortBy(subnav)
        console.log("subnav clicked", subnav)

      @layout.restaurants_subnavRegion.show subNavView

    showFilterSliders: (restaurants, sliders) ->
      filterSlidersView = @getFilterSlidersView(sliders)
     
      filterSlidersView.on "itemview:sliders:slider:clicked",
      (child, slider) ->
        sliderSelector = slider.get('cssID')
        sliderValue = $("#"+ sliderSelector).slider('getValue')
        sliderValueText = sliderValue.val()
        sliderValueArray = sliderValueText.split(',')
        slider.set({minValue: sliderValueArray[0], maxValue: sliderValueArray[1]})
        restaurants.filterBy(sliders)

      @layout.restaurantsSlidersRegion.show filterSlidersView

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

    getPanelView: (panelnavs) ->
      new List.Panels
        collection: panelnavs

    getSubNavView: (subnavs) ->
      new List.RestaurantsSubNavs
        collection: subnavs

    getRestaurantsView: (restaurants) ->
      new List.Restaurants
        collection: restaurants

    getFilterSlidersView: (sliders) ->
      new List.Sliders
        collection: sliders

    getLayoutView: ->
      new List.Layout
