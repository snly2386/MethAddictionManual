class GettingOff.Ch4 extends GettingOff.View

  className: ->
    "ch4page-#{@page}" 

  constructor: (options) ->
    @page = parseInt options.page
    super

  template: (attributes) -> JST["templates/ch4/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @answers = false
   
    @table_of_contents = options.table_of_contents
    @button = options.button

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @model.fetch
      success: (model, response, options) =>
        @model.set model.attributes[0]
        @render()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()

  events: 
    'click .button'                      : 'navigate'
    'focus .textarea textarea'           : 'focus_handler'
    'focusout .textarea textarea'        : 'focusout_handler'
    'click .finish-chapter'              : 'ch5'
    'mousedown .button, .finish-chapter' : 'mousedown_effect'
    'mouseup .button, .finish-chapter'   : 'mouseup_effect'

  mousedown_effect: ->
    @$('.button, .finish-chapter').addClass('shrunk')

  mouseup_effect: ->
    @$('.button, .finish-chapter').removeClass('shrunk')

  render_button: ->
    @$('.button, .finish-chapter, .save-answers').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}") 

   update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 4})
    model.set('page', @page)
    model.save()

  focus_handler: (e) ->
    target = @$(e.currentTarget)
    target.addClass('textarea-click')

  focusout_handler: ->
    @$('.textarea textarea').removeClass('textarea-click')

  save_answers: ->
    counter = 1
    @$('.textarea').each( =>
      console.log "answer_#{counter}"
      console.log $("." + counter).val()
      @model.set("answer_#{counter}", $("." + counter).val()) 
      counter++ 
    )
    @model.save()
    @answers = true
    console.log 'worked'


  navigate: ->
    next_page = @page += 1
    @app.navigate "ch4/#{next_page}", trigger: true

  ch5: ->
     @save_answers()
     @app.navigate "ch5/1", trigger: true

  render: ->
    @$el.html @template @model.toJSON()
