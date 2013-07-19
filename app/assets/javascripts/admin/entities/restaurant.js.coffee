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
      allRestaurants = new Entities.RestaurantsCollection
      allRestaurants.fetch()
      allRestaurants

    getFilterRestaurantEntities: (allRestaurants) ->
      console.log("unfiltered are", allRestaurants)
      filtered = new allRestaurants.constructor()
      console.log("to be filtered are", filtered)

      filtered._callbacks = {}

      filtered.filterBy = (sliders) ->
        restaurants = undefined

        if sliders
          scoreSlider = sliders.findWhere({cssID: 'score-slider'})
          mentionsSlider = sliders.findWhere({cssID: 'mentions-slider'})
          console.log("sliders pres",mentionsSlider)
          console.log("mentions slider maxval",mentionsSlider.get('maxValue'))
          ageSlider = sliders.findWhere({cssID: 'age-slider'})
          console.log("in the if sliders allrests", allRestaurants)

          restaurants = allRestaurants.filter((restaurant) ->
            restaurant.get('buzz_mention_count_ignored') > mentionsSlider.get('minValue') and
            restaurant.get('buzz_mention_count_ignored') < mentionsSlider.get('maxValue') and
            restaurant.get('total_current_buzz_rounded') > scoreSlider.get('minValue') and
            restaurant.get('total_current_buzz_rounded') < scoreSlider.get('maxValue') and
            restaurant.get('age_in_days') > ageSlider.get('minValue') and
            restaurant.get('age_in_days') < ageSlider.get('maxValue')
          )
          console.log("sliders present so",restaurants)
          restaurants

        else
          console.log("allrest.models", allRestaurants.models)
          restaurants = allRestaurants.models

        filtered._currentCriteria = sliders

        console.log("filtered before reset are", filtered)
        filtered.reset restaurants
        console.log("filtered after reset are", filtered)

      allRestaurants.on "reset", ->
        filtered.where filtered._currentCriteria

      console.log("filtered are", filtered)
      filtered
      console.log("unfiltered are", allRestaurants)
      filtered = new allRestaurants.constructor()
      console.log("to be filtered are", filtered)

      filtered._callbacks = {}

      filtered.filterBy = (sliders) ->
        restaurants = undefined

        if sliders
          scoreSlider = sliders.findWhere({cssID: 'score-slider'})
          mentionsSlider = sliders.findWhere({cssID: 'mentions-slider'})
          console.log("sliders pres",mentionsSlider)
          console.log("mentions slider maxval",mentionsSlider.get('maxValue'))
          ageSlider = sliders.findWhere({cssID: 'age-slider'})
          console.log("in the if sliders allrests", allRestaurants)

          restaurants = allRestaurants.filter((restaurant) ->
            restaurant.get('buzz_mention_count_ignored') > mentionsSlider.get('minValue') and
            restaurant.get('buzz_mention_count_ignored') < mentionsSlider.get('maxValue') and
            restaurant.get('total_current_buzz_rounded') > scoreSlider.get('minValue') and
            restaurant.get('total_current_buzz_rounded') < scoreSlider.get('maxValue') and
            restaurant.get('age_in_days') > ageSlider.get('minValue') and
            restaurant.get('age_in_days') < ageSlider.get('maxValue')
          )
          console.log("sliders present so",restaurants)
          restaurants

        else
          console.log("allrest.models", allRestaurants.models)
          restaurants = allRestaurants.models

        filtered._currentCriteria = sliders

        console.log("filtered before reset are", filtered)
        filtered.reset restaurants
        console.log("filtered after reset are", filtered)

      allRestaurants.on "reset", ->
        filtered.where filtered._currentCriteria

      console.log("filtered are", filtered)
      filtered
      
    getFilteredRestaurantsList: (restaurants, sliders) ->
      scoreSlider = sliders.findWhere({cssID: 'score-slider'})
      mentionsSlider = sliders.findWhere({cssID: 'mentions-slider'})
      ageSlider = sliders.findWhere({cssID: 'age-slider'})
      filtered_restaurants_list = restaurants.filter((restaurant) ->
        restaurant.get('buzz_mention_count_ignored') > mentionsSlider.get('minValue') and
        restaurant.get('buzz_mention_count_ignored') < mentionsSlider.get('maxValue') and
        restaurant.get('total_current_buzz_rounded') > scoreSlider.get('minValue') and
        restaurant.get('total_current_buzz_rounded') < scoreSlider.get('maxValue') and
        restaurant.get('age_in_days') > ageSlider.get('minValue') and
        restaurant.get('age_in_days') < ageSlider.get('maxValue')
      )
      filtered_restaurants = new Entities.RestaurantsCollection(filtered_restaurants_list)
      console.log("filtered_restaurants are", filtered_restaurants)
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
        { name: "Buzz Score", minValue: "0", maxValue: "1000", cssID: "score-slider", initialValue: "[0,1000]" }
        { name: "Buzz Mentions", minValue: "0", maxValue: "1000", cssID: "mentions-slider", initialValue: "[0,1000]" }
        { name: "Age(Days)", minValue: "0", maxValue: "1000", cssID: "age-slider", initialValue: "[0,1000]" }
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

  App.reqres.setHandler "restaurant:filter:entities", (allRestaurants) ->
    API.getFilterRestaurantEntities allRestaurants

  App.reqres.setHandler "restaurant:subnavs", ->
    API.getSubNavs()

  App.reqres.setHandler "new:restaurants:restaurant:view", ->
    API.newRestaurant()
