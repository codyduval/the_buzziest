Backbone.Marionette.Renderer.render = (template, data) ->
  path = JST["admin/apps/" + template]
  unless path
    path = JST["admin/components/" + template]
    unless path
      throw "Template #{template} not found!"
  path(data)
