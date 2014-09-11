class GettingOff.Ch7 extends GettingOff.View

  className: ->
    "ch7page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: -> JST["templates/ch7/#{@page}"]

  initialize: (options) ->
    @app = options.app
    @table_of_contents = options.table_of_contents

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @render()
    @position()

  events: 
    'click .button'         : 'navigate'
    'click .finish-chapter' : 'ch8'

  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 7})
    model.set('page', @page)
    model.save()

  ch8: ->
    @app.navigate "ch8/1", trigger: true

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch7/#{next_chapter}", trigger: true

  render: ->
    @$el.html @template()