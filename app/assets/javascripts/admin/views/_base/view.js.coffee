@Admin.module "Views", (Views, App, Backbone, Marionette, $, _) ->

  _.extend Marionette.View::,

    templateHelpers: ->
      #helpers that would go across app go here
