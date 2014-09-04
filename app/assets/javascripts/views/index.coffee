class GettingOff.Index extends Backbone.View
  id: 'index'
  template: JST['templates/index']

  events:
    'click .newuser' : 'new_user'

  initialize: (options) ->
    @app = options.app
    @render()
    @position()

  render: ->
    console.log @template()
    @$el.html @template()

  position: ->
    $('#app').html @$el

  new_user: ->
    @app.navigate 'new', trigger: true
    console.log 'its working'
