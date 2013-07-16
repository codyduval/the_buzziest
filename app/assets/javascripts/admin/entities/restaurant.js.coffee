@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Restaurants extends App.Entities.Model
    urlRoot: -> Routes.restaurants_path()

  class Entities.RestaurantsCollection extends App.Entities.Collection
    model: Entities.Restaurants
    url: -> Routes.restaurants_path()

  class Entities.RestaurantsSubNav extends App.Entities.Collection
    model: Entities.Restaurants

  class Entities.RestaurantsSlider extends App.Entities.Model

  class Entities.RestaurantsSliders extends App.Entities.Collection
    model: Entities.RestaurantsSlider

  API =
    getRestaurantEntities: ->
      restaurants = new Entities.RestaurantsCollection
      restaurants.fetch()
      restaurants

    getFilteredRestaurants: (restaurants, filterParams) ->
      filtered_restaurants_list = restaurants.filter((restaurant) ->
        restaurant.get('buzz_mention_count_ignored') > filterParams.mentionLow and
        restaurant.get('buzz_mention_count_ignored') < filterParams.mentionHigh and
        restaurant.get('total_current_buzz_rounded') > filterParams.scoreLow and
        restaurant.get('total_current_buzz_rounded') < filterParams.scoreHigh and
        restaurant.get('age_in_days') > filterParams.ageLow and
        restaurant.get('age_in_days') < filterParams.ageHigh
      )
      filtered_restaurants = new Entities.RestaurantsCollection(filtered_restaurants_list)

      filtered_restaurants

    getSubNavs: ->
      new Entities.RestaurantsSubNav [
        { name: "New York" }
        { name: "San Francisco" }
        { name: "Los Angeles" }
        { name: "All" }
      ]

    getRestaurantSliders: ->
      new Entities.RestaurantsSliders [
        { name: "Buzz Score", minValue: "0", maxValue: "100", cssID: "score-slider", initialValue: "[0,100]" }
        { name: "Buzz Mentions", minValue: "0", maxValue: "100", cssID: "mentions-slider", initialValue: "[0,100]" }
        { name: "Age(Days)", minValue: "0", maxValue: "100", cssID: "age-slider", initialValue: "[0,100]" }
      ]

    newRestaurant: ->
      RestaurantsApp.New.Controller.newRestaurant()

    getRestaurant: (id) ->
      restaurant = new Entities.Restaurants
        id: id
      restaurant.fetch()
      restaurant

    getRestaurantFilterValues: (restaurants) ->
      filterParams = {}
      console.log(restaurants)
      lowestMention = restaurants.min((restaurant) ->
        restaurant.get('buzz_mention_count_ignored')
      )
      highestMention = restaurants.max((restaurant) ->
        restaurant.get('buzz_mention_count_ignored')
      )
      filterParams.mentionHigh = highestMention.get('buzz_mention_count_ignored')
      filterParams.mentionLow = lowestMention.get('buzz_mention_count_ignored')

      lowestScore = restaurants.min((restaurant) ->
        restaurant.get('total_current_buzz_rounded')
      )
      highestScore = restaurants.max((restaurant) ->
        restaurant.get('total_current_buzz_rounded')
      )
      filterParams.scoreHigh = highestScore.get('total_current_buzz_rounded')
      filterParams.scoreLow = lowestScore.get('total_current_buzz_rounded')

      lowestAge = restaurants.min((restaurant) ->
        restaurant.get('age_in_days')
      )
      highestAge = restaurants.max((restaurant) ->
        restaurant.get('age_in_days')
      )
      filterParams.ageHigh = highestAge.get('age_in_days')
      filterParams.ageLow = lowestAge.get('age_in_days')
      console.log(filterParams)

      filterParams

  App.reqres.setHandler "restaurant:entities", ->
    API.getRestaurantEntities()

  App.reqres.setHandler "restaurant:sliders", ->
    API.getRestaurantSliders()

  App.reqres.setHandler "restaurant:filterValues", (restaurants) ->
    API.getRestaurantFilterValues(restaurants)

  App.reqres.setHandler "restaurants:entity", (id) ->
    API.getRestaurant id

  App.reqres.setHandler "restaurants:filtered:entities", (restaurants, filterParams) ->
    API.getFilteredRestaurants(restaurants, filterParams)

  App.reqres.setHandler "restaurant:subnavs", ->
    API.getSubNavs()

  App.reqres.setHandler "new:restaurants:restaurant:view", ->
    API.newRestaurant()
