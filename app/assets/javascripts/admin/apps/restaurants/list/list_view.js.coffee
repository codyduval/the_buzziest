@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "restaurants/list/templates/list_layout"

    regions:
      restaurantsPanelRegion: "#restaurants-panel-region"
      restaurantsListRegion: "#restaurants-list-region"

  class List.Panel extends App.Views.ItemView
    template: "restaurants/list/templates/_restaurants_panel"

    collectionEvents:
      "reset" : "render"

  class List.Restaurant extends App.Views.ItemView
    template: "restaurants/list/templates/_restaurant"
    tagName: "tr"

  class List.Empty extends App.Views.ItemView
    template: "restaurants/list/templates/_empty"
    tagName: "tr"
    
  class List.Restaurants extends App.Views.CompositeView
    template: "restaurants/list/templates/_restaurants"
    itemView: List.Restaurant
    emptyView: List.Empty
    itemViewContainer: "tbody"
