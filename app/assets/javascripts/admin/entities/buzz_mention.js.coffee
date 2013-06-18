@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BuzzMention extends Entities.Model

  class Entities.BuzzMentionsCollection extends Entities.Collection
    model: Entities.BuzzMention
    url: -> Routes.buzz_mentions_path()

  class Entities.BuzzMentionsSubNav extends Entities.Collection
    model: Entities.BuzzMention
    
  API =
    getBuzzMentionEntities: (cb) ->
      buzz_mentions = new Entities.BuzzMentionsCollection
      buzz_mentions.fetch
        #don't need reset: true now b/c using call back to wait to render
        reset: true
        success: ->
          cb buzz_mentions

    getSubNavs: ->
      new Entities.BuzzMentionsSubNav [
        { name: "New York" }
        { name: "San Francisco" }
        { name: "Los Angeles" }
        { name: "All" }
      ]

  App.reqres.setHandler "buzz_mention:entities", (cb) ->
    API.getBuzzMentionEntities cb
    
  App.reqres.setHandler "buzz_mention:subnavs", ->
    API.getSubNavs()
