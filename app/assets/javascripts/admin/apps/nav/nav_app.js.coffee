@Admin.module "NavApp", (NavApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    listNav: ->
      NavApp.List.Controller.listNav()

  NavApp.on "start", ->
    API.listNav()
