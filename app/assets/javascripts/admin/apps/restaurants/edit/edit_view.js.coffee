@Admin.module "RestaurantsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "restaurants/edit/templates/edit_layout"

    regions:
      formRegion: "#form-region"

  class Edit.ModalLayout extends App.Views.Layout
    template: "restaurants/edit/templates/modal_edit_layout"

    dialog:
      title: "Edit Restaurant"
      className: "dialogClass"
      buttons: [
        {
        text: "Create"
        "class": "btn btn-success btn-small"
        click: =>
          @currentView.triggerMethod "dialog:save:button:clicked"},
        {text: "Cancel"
        "class": "btn btn-small"
        click: =>
          @currentView.triggerMethod "dialog:cancel:button:clicked"}
        ]

    regions:
      formRegion: "#form-region"

    onDialogSaveButtonClicked: ->
      console.log "save button clicked"

    onDialogCancelButtonClicked: ->
      console.log "cancel button clicked"

   class Edit.Restaurant extends App.Views.ItemView
     template: "restaurants/edit/templates/edit_restaurant"

     form:
       focusFirstInput: true
       buttons:
         primary: "foo"
         cancel: "bar cancel"
         placement: "left"
