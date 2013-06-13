@Admin.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BuzzMention extends Entities.Model

  class Entities.BuzzMentionsCollection extends Entities.Collection
    model: Entities.BuzzMention
    url: -> Routes.buzz_mentions_path()

  API =
    getBuzzMentionEntities: ->
      buzz_mentions = new Entities.BuzzMentionsCollection
      buzz_mentions.fetch
        reset: true
      buzz_mentions

  App.reqres.setHandler "buzz_mention:entities", ->
    API.getBuzzMentionEntities()
