@Admin.module "RestaurantsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "restaurants/edit/templates/edit_layout"

    regions:
      formRegion: "#form-region"

   class Edit.Restaurant extends App.Views.ItemView
     template: "restaurants/edit/templates/edit_restaurant"

     form:
       focusFirstInput: true
       buttons:
         primary: "foo"
         cancel: "bar cancel"
         placement: "left"
