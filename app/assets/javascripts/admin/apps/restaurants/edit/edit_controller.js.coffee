@Admin.module "RestaurantsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  Edit.Controller =

    editRestaurant: (id, restaurant) ->
      restaurant or= App.request "restaurants:entity", id
      editView = @getEditView restaurant

      App.mainRegion.show editView

    getEditView: (restaurant) ->
      new Edit.Restaurant
        model: restaurant
