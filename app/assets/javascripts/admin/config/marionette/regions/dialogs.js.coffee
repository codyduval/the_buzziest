do (Backbone, Marionette) ->

  class Marionette.Region.Dialog extends Marionette.Region

    # onShow: (view) ->
    #   options = @getDefaultOptions _.result(view, "dialog")
    #   buttons = $('.ui-dialog-buttonset').children('button')
    #   @$el.dialog options,
    #     @resetButtons buttons
    #     close: (e, ui) =>
    #       @closeDialog()

     onShow: (view) ->
       @$el.modal('show')
       
    getDefaultOptions: (options = {}) ->
      _.defaults options,
        title: "The Buzziest"
        dialogClass: options.className
        buttons: [
          text: options.button ? "Ok"
          click: =>
            @currentView.triggerMethod "dialog:button:clicked"
        ]

    closeDialog: ->
      @close()
      @$el.dialog("destroy")
