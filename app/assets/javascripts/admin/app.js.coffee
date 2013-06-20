@Admin = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = Routes.buzz_mentions_path()

  App.addRegions
    mainRegion: "#main-region"
    navRegion: "#nav-region"
    dialogRegion: Marionette.Region.Dialog.extend el: "#dialog-region"

  App.addInitializer ->
    App.module("NavApp").start()

  App.on "initialize:after", ->
    if Backbone.history
      Backbone.history.start()
      @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""

  App
