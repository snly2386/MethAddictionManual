class GettingOff.Ch7 extends GettingOff.View

  className: ->
    "ch7page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: -> JST["templates/ch7/#{@page}"]

  initialize: (options) ->
    @app = options.app

    @render()
    @position()

  events: 
    'click .button'         : 'navigate'
    'click .finish-chapter' : 'ch8'

  ch8: ->
    @app.navigate "ch8/1", trigger: true

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch7/#{next_chapter}", trigger: true

  render: ->
    @$el.html @template()