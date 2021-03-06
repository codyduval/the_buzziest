@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BuzzMention extends Entities.Model

  class Entities.BuzzMentionsCollection extends Entities.Collection
    model: Entities.BuzzMention
    url: -> Routes.buzz_mentions_path()

  API =
    getBuzzMentionEntities: (cb) ->
      buzz_mentions = new Entities.BuzzMentionsCollection
      buzz_mentions.fetch
        #don't need reset: true now b/c using call back to wait to render
        reset: true
        success: ->
          cb buzz_mentions

  App.reqres.setHandler "buzz_mention:entities", (cb) ->
    API.getBuzzMentionEntities cb
