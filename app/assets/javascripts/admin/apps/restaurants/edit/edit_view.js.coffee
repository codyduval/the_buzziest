@Admin.module "RestaurantsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Restaurant extends App.Views.ItemView
    template: "restaurants/edit/templates/edit_restaurant"
