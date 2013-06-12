@Admin.module "NavApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showNav: ->
      navView = @getNavView()
      App.navRegion.show navView

    getNavView: ->
      new Show.Nav
