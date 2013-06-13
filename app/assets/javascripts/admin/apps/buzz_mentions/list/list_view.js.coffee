@Admin.module "BuzzMentionsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "buzz_mentions/list/templates/list_layout"

    regions:
      panelRegion: "#panel-region"
      buzz_mentionsRegion: "#buzz-mentions-region"

  class List.Panel extends App.Views.ItemView
    template: "buzz_mentions/list/templates/_panel"

  class List.BuzzMention extends App.Views.ItemView
    template: "buzz_mentions/list/templates/_buzz_mention"
    tagName: "tr"

  class List.BuzzMentions extends App.Views.CompositeView
    template: "buzz_mentions/list/templates/_buzz_mentions"
    itemView: List.BuzzMention
    itemViewContainer: "tbody"
