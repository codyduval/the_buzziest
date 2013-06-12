@Admin.module "NavApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listNav: ->
      links = App.request "nav:entities"
      window.links = links

      navView = @getNavView links
      App.navRegion.show navView

    getNavView: (links) ->
      new List.Navs
        collection: links
