@Admin.module "NavApp", (NavApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showNav: ->
      NavApp.Show.Controller.showNav()

  NavApp.on "start", ->
    API.showNav()
