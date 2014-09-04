class GettingOff.Ch5 extends GettingOff.View

  className: ->
    "ch5page-#{@page}"

  constructor: (options) ->
    @page = parseInt options.page
    super

  template: (attributes) -> JST["templates/ch5/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @names = options.names
    
    @model.fetch
      success: (model, response, options) =>
        @model.set model.attributes[0]
        @render()
        @position()

    @names.fetch
      success:(model, response, options) =>
        @render_names()
    @make_draggable()

  events: ->
    'click .button'               : 'navigate'
    'focus .textarea textarea'    : 'focus_handler'
    'focusout .textarea textarea' : 'focusout_handler'
    'click .save-answers'         : 'save_answers'
    'click .me'                   : 'popup_menu'
    'click .submit'               : 'create_person'
    'click .float-shadow'         : 'float_effect'

  float_effect: (e) ->
    target = @$(e.currentTarget)
    $('.float-shadow').removeClass('float-shadow-click')
    target.addClass('float-shadow-click')

  focus_handler: (e) ->
    target = @$(e.currentTarget)
    target.addClass('textarea-click')

  focusout_handler: ->
    @$('.textarea textarea').removeClass('textarea-click')

  popup_menu: ->
    @$('.name').val("")
    @$('.popup-menu').show 'slide',{direction: 'down'}, 1000

  make_draggable: ->
    @$('.circle').draggable({containment: '.web'})

  create_person: ->
    person = @$('.name').val()
    color_data = @$(".float-shadow-click").data('color')
    name = new GettingOff.Ch5_Name "name" : person, "color" : color_data
    console.log "LOOK AT THIS SHIT" + person + "COLOR " + color_data
    @names.create(name)
    div = "<div class='circle font-sans' style='background-color:#{color_data}'>#{person}</div>"
    @append(div)
    @make_draggable()
    @$(".popup-menu").hide 'slide', {direction: 'down'}, 1000

  append: (div)->
    $('.web .me').append(div)

  render_names: ->
    console.log 'rendering shit'
    console.log @names
    margin = 0
    @names.each (model) ->
      console.log @$('.web')
      console.log "<div class='circle font-sans'>#{model.get('name')}</div>"
      $('.web .me').append("<div class='circle font-sans' style='background-color: #{model.get('color')}; margin-left: #{margin}px'>#{model.get('name')}</div>")
      margin+=20
    
  save_answers: ->
    counter = 1
    @$('.textarea').each( =>
      @model.set("answer_#{counter}", $(".#{counter}").val())
      counter++
      )
    @model.save()
    @navigate()

  navigate: ->
    next_page = @page + 1
    @app.navigate "ch5/#{next_page}", trigger: true

  render: ->
    @$el.html @template @model.toJSON()