@Admin.module "Views", (Views, App, Backbone, Marionette, $, _) ->

  _remove = Marionette.View::remove
  
  _.extend Marionette.View::,

    remove: (args...) ->
      _remove.apply @, args

    templateHelpers: ->

      linkTo: (name, url, options ={}) ->
        _.defaults options,
          external: false

        url = "#" + url unless options.external
        
        "<a href='#{url}'>#{@escape(name)}</a>"
        
