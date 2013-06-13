@Admin.module "BuzzMentionsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listBuzzMentions: ->
      buzz_mentions = App.request "buzz_mention:entities"

      @layout = @getLayoutView()

      @layout.on "show", =>
        @showPanel buzz_mentions
        @showBuzzMentions buzz_mentions

      App.mainRegion.show @layout
   
    showPanel: (buzz_mentions) ->
      panelView = @getPanelView buzz_mentions
      @layout.panelRegion.show panelView

    showBuzzMentions: (buzz_mentions) ->
      buzz_mentionsView = @getBuzzMentionsView buzz_mentions
      @layout.buzz_mentionsRegion.show buzz_mentionsView

    getPanelView: (buzz_mentions) ->
      new List.Panel
        collection: buzz_mentions

    getBuzzMentionsView: (buzz_mentions) ->
      new List.BuzzMentions
        collection: buzz_mentions

    getLayoutView: ->
      new List.Layout
