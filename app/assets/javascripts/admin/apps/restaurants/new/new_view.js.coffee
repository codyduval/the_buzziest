@Admin.module "RestaurantsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Restaurant extends App.Views.ItemView
    template: "restaurants/new/templates/new_restaurant"
    tagName: "tr"

    triggers:
      "click #new-cancel" : "form:cancel:button:clicked"
