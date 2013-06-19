@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "restaurants/list/templates/list_layout"

    regions:
      restaurants_newRegion: "#restaurants-new-region"
      restaurantsPanelRegion: "#restaurants-panel-region"
      restaurantsListRegion: "#restaurants-list-region"
      restaurants_subnavRegion: "#restaurants-subnav-region"

  class List.Panel extends App.Views.ItemView
    template: "restaurants/list/templates/_restaurants_panel"
    
    triggers:
      "click #new-restaurant" : "new:restaurants:button:clicked"

  class List.Restaurant extends App.Views.ItemView
    template: "restaurants/list/templates/_restaurant"
    tagName: "tr"

    events:
      "click button.edit-restaurant" : -> @trigger "restaurants:restaurant:clicked", @model

  class List.Empty extends App.Views.ItemView
    template: "restaurants/list/templates/_empty"
    tagName: "tr"
    
  class List.Restaurants extends App.Views.CompositeView
    template: "restaurants/list/templates/_restaurants"
    itemView: List.Restaurant
    emptyView: List.Empty
    itemViewContainer: "tbody"

  class List.RestaurantsSubNav extends App.Views.ItemView
    template: "restaurants/list/templates/_sub_nav"
    tagName: "li"

  class List.RestaurantsSubNavs extends App.Views.CompositeView
    template: "restaurants/list/templates/subnavs"
    itemView: List.RestaurantsSubNav
    itemViewContainer: "ul.nav-tabs"
