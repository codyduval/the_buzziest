@Admin = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.addRegions
    mainRegion: "#main-region"
    navRegion: "#nav-region"

  App.addInitializer ->
    App.module("NavApp").start()

  App.on "initialize:after", ->
    if Backbone.history
      Backbone.history.start()

  App
