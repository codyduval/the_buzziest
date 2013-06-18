@Admin.module "BuzzMentionsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "buzz_mentions/list/templates/list_layout"

    regions:
      panelRegion: "#panel-region"
      buzz_mentionsRegion: "#buzz-mentions-region"
      buzz_mentions_subnavRegion: "#buzz-mentions-subnav-region"

  class List.Panel extends App.Views.ItemView
    template: "buzz_mentions/list/templates/_panel"

    collectionEvents:
      "reset" : "render"

  class List.BuzzMention extends App.Views.ItemView
    template: "buzz_mentions/list/templates/_buzz_mention"
    tagName: "tr"

  class List.Empty extends App.Views.ItemView
    template: "buzz_mentions/list/templates/_empty"
    tagName: "tr"
    
  class List.BuzzMentions extends App.Views.CompositeView
    template: "buzz_mentions/list/templates/_buzz_mentions"
    itemView: List.BuzzMention
    emptyView: List.Empty
    itemViewContainer: "tbody"

  class List.BuzzMentionsSubNav extends App.Views.ItemView
    template: "buzz_mentions/list/templates/_sub_nav"
    tagName: "li"

  class List.BuzzMentionsSubNavs extends App.Views.CompositeView
    template: "buzz_mentions/list/templates/subnavs"
    itemView: List.BuzzMentionsSubNav
    itemViewContainer: "ul.nav-tabs"
