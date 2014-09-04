class GettingOff.Ch2 extends GettingOff.View

  className: ->
    "page_#{@page}"

  constructor: (options) ->
    @page = parseInt options.page
    super

  template: -> JST["templates/ch2/#{@page}"]

  initialize: (options) ->
    @app = options.app
    #@pages = [0..]

    @render()
    @position()

  navigate: ->
    @app.navigate "ch2/#{}", trigger: true
