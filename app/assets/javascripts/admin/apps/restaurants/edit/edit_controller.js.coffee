@Admin.module "RestaurantsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  Edit.Controller =

    editRestaurant: (id, restaurant) ->
      restaurant or= App.request "restaurants:entity", id

      App.execute "when:fetched", [restaurant], =>
        @layout = @getLayoutView restaurant

        @layout.on "show", =>
          @showFormRegion restaurant

        App.mainRegion.show @layout

    showFormRegion: (restaurant) ->
      editView = @getEditView restaurant

      formView = App.request "form:wrapper", editView

      @layout.formRegion.show formView

    getLayoutView: (restaurant) ->
      new Edit.Layout
        model: restaurant
   
    getEditView: (restaurant) ->
      new Edit.Restaurant
        model: restaurant

