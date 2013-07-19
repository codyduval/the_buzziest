@Admin.module "RestaurantsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "restaurants/list/templates/list_layout"

    regions:
      restaurantsPanelRegion: "#restaurants-panel-region"
      restaurantsListRegion: "#restaurants-list-region"
      restaurants_subnavRegion: "#restaurants-subnav-region"
      restaurants_newRegion: "#restaurants-new-region"
      restaurantsSlidersRegion: "#restaurants-sliders-region"

  class List.Panel extends App.Views.ItemView
    template: "restaurants/list/templates/_restaurants_panel"
    tagName: "li"

    events:
      "click a" : ->
        @trigger "panel:panelnavs:clicked", @model

  class List.Panels extends App.Views.CompositeView
    template: "restaurants/list/templates/_restaurants_panels"
    itemView: List.Panel
    itemViewContainer: "ul"
    
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

    events:
      "click a" : ->
        @trigger "subnavs:subnav:clicked", @model

  class List.RestaurantsSubNavs extends App.Views.CompositeView
    template: "restaurants/list/templates/subnavs"
    itemView: List.RestaurantsSubNav
    itemViewContainer: "ul.nav-tabs"

  class List.Slider extends App.Views.ItemView
    template: "restaurants/list/templates/_slider"
    tagName: "span"
    initialize: ->
      @$el.prop("id", "slider-" + this.model.get("cssID"))

    events:
      "slideStop .slider" : ->
        @trigger "sliders:slider:clicked", @model

  class List.Sliders extends App.Views.CompositeView
    template: "restaurants/list/templates/_sliders"
    itemView: List.Slider
    itemViewContainer: "#sliders-go-here"
          
    onShow: ->
      $('#score-slider').slider()
      $('#mentions-slider').slider()
      $('#age-slider').slider()


