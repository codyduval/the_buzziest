@Admin = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = Routes.restaurants_path()

  App.addRegions
    mainRegion: "#main-region"
    navRegion: "#nav-region"

  App.addInitializer ->
    App.module("NavApp").start()

  App.on "initialize:after", ->
    if Backbone.history
      Backbone.history.start()
      @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""

  App
