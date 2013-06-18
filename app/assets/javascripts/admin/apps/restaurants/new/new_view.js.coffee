@Admin.module "RestaurantsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Restaurants extends App.Views.ItemView
    template: "restaurants/new/templates/new_restaurant"

    triggers:
      "click #new-cancel" : "form:cancel:button:clicked"
