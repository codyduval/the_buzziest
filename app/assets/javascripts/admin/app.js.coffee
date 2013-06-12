@Demo = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.addRegions
    mainRegion "#main-region"
    navRegion "#nav-region"

  App.on "initialize:after", ->
    if Backbone.history
      Backgone.history.start()

  App
