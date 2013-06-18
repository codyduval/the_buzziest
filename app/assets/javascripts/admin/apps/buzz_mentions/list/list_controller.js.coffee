@Admin.module "BuzzMentionsApp.List", (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    listBuzzMentions: ->
      App.request "buzz_mention:entities", (buzz_mentions) =>

        subnavs = App.request "buzz_mention:subnavs"
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showSubNavView subnavs
          @showPanel buzz_mentions
          @showBuzzMentions buzz_mentions

        App.mainRegion.show @layout
   
    
    showPanel: (buzz_mentions) ->
      panelView = @getPanelView buzz_mentions
      @layout.panelRegion.show panelView

    showSubNavView: (subnavs) ->
      subNavView = @getSubNavView subnavs
      @layout.buzz_mentions_subnavRegion.show subNavView

    showBuzzMentions: (buzz_mentions) ->
      buzz_mentionsView = @getBuzzMentionsView buzz_mentions
      @layout.buzz_mentionsRegion.show buzz_mentionsView

    getPanelView: (buzz_mentions) ->
      new List.Panel
        collection: buzz_mentions

    getSubNavView: (subnavs) ->
      new List.BuzzMentionsSubNavs
        collection: subnavs

    getBuzzMentionsView: (buzz_mentions) ->
      new List.BuzzMentions
        collection: buzz_mentions

    getLayoutView: ->
      new List.Layout
