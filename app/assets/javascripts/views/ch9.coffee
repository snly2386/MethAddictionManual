class GettingOff.Ch9 extends GettingOff.View

  className: ->
    "ch9page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: (attributes)-> JST["templates/ch9/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @page3_model = options.page3_model
    @table_of_contents = options.table_of_contents
    @button = options.button

    @page3_model.fetch
      success:(model, response, options) =>
        @page3_model.set model.attributes[0]

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @render()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()

  events: ->
    'click .button'               : 'navigate'
    'click .rating p'             : 'select_rating'
    'focus .textarea textarea'    : 'focus_handler'
    'focusout .textarea textarea' : 'focusout_handler'
    'click .finish-chapter'        : 'page3_save'

  render_button: ->
    @$('.button, .finish-chapter, .page2-model, .page9-model').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")

  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 9})
    model.set('page', @page)
    model.save()

  page3_save: ->
    console.log 'it'
    counter = 1
    @$('.textarea').each( =>
        @page3_model.set("question_#{counter}", $(".#{counter}").val())
        counter++
      )
    @page3_model.save()
    console.log 'worked'

  focus_handler: (e) ->
    target = @$(e.currentTarget)
    target.addClass('textarea-click')

  focusout_handler: (e) ->
    target = @$(e.currentTarget)
    target.removeClass('textarea-click')


  select_rating: (e) ->
    target = @$(e.currentTarget)
    target.siblings().removeClass 'glowing'
    target.addClass 'glowing'

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch9/#{next_chapter}", trigger: true

  render: ->
    @$el.html @template @page3_model.toJSON()
