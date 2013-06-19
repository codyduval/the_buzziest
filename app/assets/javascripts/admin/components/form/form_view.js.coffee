@Admin.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->

  class Form.FormWrapper extends App.Views.Layout
    template: "form/templates/form"

    tagName: "div"
    attributes: ->
      "class" : @getFormClassType()

    regions:
      formContentRegion: "#form-content-region"

    onShow: ->
      _.defer =>
        @focusFirstInput() if @options.config.focusFirstInput

    focusFirstInput: ->
      @$(":input:visible:enabled:first").focus()

    getFormClassType: ->
      if @model.isNew() then "alert alert-success" else "alert"

