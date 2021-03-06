@Admin.module "NavApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Nav extends App.Views.ItemView
    template: "nav/list/templates/_nav"
    tagName: "li"

  class List.Navs extends App.Views.CompositeView
    template: "nav/list/templates/navs"
    itemView: List.Nav
    itemViewContainer: "ul"
