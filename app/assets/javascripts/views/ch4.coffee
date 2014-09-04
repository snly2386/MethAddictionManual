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
    # console.log "model: " + @model
    # console.log @model
    @model.fetch
      success: (model, response, options) =>
        @model.set model.attributes[0]
        @render()
        @position()

  events: 
    'click .button'               : 'navigate'
    'focus .textarea textarea'    : 'focus_handler'
    'focusout .textarea textarea' : 'focusout_handler'
    'click .finish-chapter'       : 'ch5'

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
