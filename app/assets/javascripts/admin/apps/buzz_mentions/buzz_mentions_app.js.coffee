@Admin.module "BuzzMentionsApp", (BuzzMentionsApp, App, Backbone, Marionette, $, _) ->

  class BuzzMentionsApp.Router extends Marionette.AppRouter
    appRoutes:
      "buzz_mentions" : "listBuzzMentions"
  
  API =
    listBuzzMentions: ->
      BuzzMentionsApp.List.Controller.listBuzzMentions()

  App.addInitializer ->
    new BuzzMentionsApp.Router
      controller: API
