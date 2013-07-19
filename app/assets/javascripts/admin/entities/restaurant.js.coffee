@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Restaurants extends App.Entities.Model
    urlRoot: -> Routes.restaurants_path()

  class Entities.RestaurantsCollection extends App.Entities.Collection
    model: Entities.Restaurants
    url: -> Routes.restaurants_path()

  class Entities.RestaurantsSubNav extends App.Entities.Collection

  class Entities.RestaurantsSlider extends App.Entities.Model

  class Entities.RestaurantsSliders extends App.Entities.Collection
    model: Entities.RestaurantsSlider

  class Entities.RestaurantsPanelNavs extends App.Entities.Collection
    model: Entities.Restaurants

  API =
    getRestaurantEntities: ->
      allRestaurants = new Entities.RestaurantsCollection
      allRestaurants.fetch()
      allRestaurants

    getFilterRestaurantEntities: (allRestaurants) ->
      filtered = new allRestaurants.constructor()

      filtered._callbacks = {}
      filtered.subNavSortBy = (subnav) ->
        if subnav
          city = subnav.get('name')
          console.log("city in subnav", city)
          console.log("nyc", allRestaurants.where({city: "nyc"}))
          
          city = switch
            when city is 'All' then restaurants = allRestaurants.models
            when city is 'New York' then restaurants = allRestaurants.where({city: "nyc"})
            when city is 'Los Angeles' then restaurants = allRestaurants.where({city: "la"})
            when city is 'San Francisco' then restaurants = allRestaurants.where({city: "sf"})

        filtered.reset restaurants
        console.log("filtered via subnav", filtered)

      filtered.panelSortBy = (panelnav) ->
        restaurants = undefined
        if panelnav
          name = panelnav.get('name')

          name = switch
            when name is 'All' then restaurants = allRestaurants.models
            when name is 'New' then restaurants = allRestaurants.filter((restaurant) ->
              restaurant.get('age_in_days') <= 1.9
            )
            when name is 'Expiring' then restaurants = allRestaurants.filter((restaurant) ->
              restaurant.get('age_in_days') >= 90 and
              restaurant.get('total_current_buzz_rounded') <= 0.5
            )

        filtered.reset restaurants
        console.log("filtered via panel", filtered)

      filtered.filterBy = (sliders) ->
        restaurants = undefined

        if sliders
          scoreSlider = sliders.findWhere({cssID: 'score-slider'})
          mentionsSlider = sliders.findWhere({cssID: 'mentions-slider'})
          ageSlider = sliders.findWhere({cssID: 'age-slider'})
          console.log("MentionsMin:", mentionsSlider.get('minValue'))
          console.log("MentionsMax:", mentionsSlider.get('maxValue'))
          console.log("ScoreMin:", scoreSlider.get('minValue'))
          console.log("ScoreMax:", scoreSlider.get('maxValue'))
          console.log("AgeMin:", ageSlider.get('minValue'))
          console.log("AgeMax:", ageSlider.get('maxValue'))

          restaurants = allRestaurants.filter((restaurant) ->
            restaurant.get('buzz_mention_count_ignored') >= mentionsSlider.get('minValue') and
            restaurant.get('buzz_mention_count_ignored') <= mentionsSlider.get('maxValue') and
            restaurant.get('total_current_buzz_rounded') >= scoreSlider.get('minValue') and
            restaurant.get('total_current_buzz_rounded') <= scoreSlider.get('maxValue') and
            restaurant.get('age_in_days') >= ageSlider.get('minValue') and
            restaurant.get('age_in_days') <= ageSlider.get('maxValue')
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
      
    getSubNavs: ->
      new Entities.RestaurantsSubNav [
        { name: "New York" }
        { name: "San Francisco" }
        { name: "Los Angeles" }
        { name: "All" }
      ]

    getPanelNavs: (panelParams) ->
      new Entities.RestaurantsPanelNavs [
        { name: "All", value: panelParams.allRestaurantsCount }
        { name: "New", value: panelParams.newRestaurantsCount }
        { name: "Expiring", value: panelParams.expiringRestaurantsCount }
      ]

    getRestaurantSliders: (filterParams) ->
      console.log("filterParams",filterParams)
      new Entities.RestaurantsSliders [
        { name: "Buzz Score", minValue: filterParams.scoreLow, maxValue: filterParams.scoreHigh, cssID: "score-slider", initialValue: filterParams.scoreStartRange, step:"0.1" }
        { name: "Buzz Mentions", minValue: filterParams.mentionLow, maxValue: filterParams.mentionHigh, cssID: "mentions-slider", initialValue: filterParams.mentionStartRange, step:"1" }
        { name: "Age(Days)", minValue: filterParams.ageLow, maxValue: filterParams.ageHigh, cssID: "age-slider", initialValue: filterParams.ageStartRange, step:"1" }
      ]

    newRestaurant: ->
      RestaurantsApp.New.Controller.newRestaurant()

    getRestaurant: (id) ->
      restaurant = new Entities.Restaurants
        id: id
      restaurant.fetch()
      restaurant
    
    getPanelValues: (restaurants) ->
      panelParams = {}
      panelParams.allRestaurantsCount = restaurants.length
      panelParams.newRestaurantsCount = restaurants.filter((restaurant) ->
        restaurant.get('age_in_days') <= 1.9
      ).length
      panelParams.expiringRestaurantsCount = restaurants.filter((restaurant) ->
        restaurant.get('age_in_days') >= 90 and
        restaurant.get('total_current_buzz_rounded') <= 0.5
      ).length
      console.log("panelparams", panelParams)

      panelParams


    getRestaurantFilterValues: (restaurants) ->
      filterParams = {}
      lowestMention = restaurants.min((restaurant) ->
        restaurant.get('buzz_mention_count_ignored')
      )
      highestMention = restaurants.max((restaurant) ->
        restaurant.get('buzz_mention_count_ignored')
      )
      filterParams.mentionHigh = highestMention.get('buzz_mention_count_ignored')
      filterParams.mentionLow = lowestMention.get('buzz_mention_count_ignored')
      filterParams.mentionStartRange = ("[" + filterParams.mentionLow + "," + filterParams.mentionHigh + "]")

      lowestScore = restaurants.min((restaurant) ->
        restaurant.get('total_current_buzz_rounded')
      )
      highestScore = restaurants.max((restaurant) ->
        restaurant.get('total_current_buzz_rounded')
      )
      filterParams.scoreHigh = highestScore.get('total_current_buzz_rounded')
      filterParams.scoreLow = lowestScore.get('total_current_buzz_rounded')
      filterParams.scoreStartRange = ("[" + filterParams.scoreLow + "," + filterParams.scoreHigh + "]")

      lowestAge = restaurants.min((restaurant) ->
        restaurant.get('age_in_days')
      )
      highestAge = restaurants.max((restaurant) ->
        restaurant.get('age_in_days')
      )
      filterParams.ageHigh = highestAge.get('age_in_days')
      filterParams.ageLow = lowestAge.get('age_in_days')
      filterParams.ageStartRange = ("[" + filterParams.ageLow + "," + filterParams.ageHigh + "]")
      console.log(filterParams)

      filterParams

  App.reqres.setHandler "restaurant:entities", ->
    API.getRestaurantEntities()

  App.reqres.setHandler "restaurant:sliders", (restaurants) ->
    filterParams = API.getRestaurantFilterValues(restaurants)
    API.getRestaurantSliders(filterParams)

  App.reqres.setHandler "restaurants:entity", (id) ->
    API.getRestaurant id

  App.reqres.setHandler "restaurant:filter:entities", (allRestaurants) ->
    API.getFilterRestaurantEntities allRestaurants

  App.reqres.setHandler "restaurant:subnavs", ->
    API.getSubNavs()

  App.reqres.setHandler "restaurant:panelnavs", (restaurants) ->
    panelParams = API.getPanelValues(restaurants)
    API.getPanelNavs(panelParams)

  App.reqres.setHandler "new:restaurants:restaurant:view", ->
    API.newRestaurant()
