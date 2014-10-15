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
    @avatar = options.avatar

    @page_animation()
    @fastclick()

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @model.fetch
      success: (model, response, options) =>
        @model.set model.attributes[0]
        @render()
        @render_answers()
        @position()

    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
        @render_avatar()

    if @page is 7
      @point_animation()
      @play_sound()
      
    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()


  events: 
    'click .button'                      : 'navigate'
    'focus .textarea textarea'           : 'focus_handler'
    'focusout .textarea textarea'        : 'focusout_handler'
    'click .finish-chapter'              : 'ch5'
    'mousedown .button, .finish-chapter' : 'mousedown_effect'
    'mouseup .button, .finish-chapter'   : 'mouseup_effect'
    'click .calendar'                    : 'calendar'
    'click .table'                       : 'go_to_table_of_contents'
    'click .user'                        : 'user'
    'click .pin'                         : 'pinboard'
    'click .previous'                    : 'previous'
    'click .page4-model'                 : 'page4_model'

  fastclick: ->
    FastClick.attach(document.body)

  scroll_to_avatar: ->
    scrollElement = document.getElementById("mid-container")
    target = $('#mid-container')
    $('#mid-container').animate({scrollTop: scrollElement.scrollHeight}, 2000)
    @$('.avatar-container').fadeIn(2000)

  render_avatar: ->
    src = @avatar.get('image')
    filename = src.split(".")[0]
    updated_filename = filename + "_middle.png"
    @$('.avatar-container img').attr('src', "#{updated_filename}")

  play_sound: ->
    bell_chime = new buzz.sound("/sounds/bell_chime.mp3")
    bell_chime.play()

  point_animation: ->
    scroll_to_avatar = @scroll_to_avatar
    window.setTimeout (->
     $(".overlay").fadeIn(1000)
     return
  ), 2000

    window.setTimeout (->
     $('.points-container').addClass('animated')
     $('.points-container').addClass('rollOut')
     return 
  ), 3000

    window.setTimeout (->
     $('.score').text('800')
     return 
  ), 4000

    window.setTimeout (->
     $('.points-container').removeClass('rollOut')
     $('.points-container').addClass('bounceInDown')
     $('.overlay').fadeOut(3000)
     return 
  ), 5000


    window.setTimeout (->
     scroll_to_avatar()
     return 
  ), 6000

  previous: ->
    window.history.go(-1)

  user: ->
    @app.navigate 'finish_setup', trigger: true

  go_to_table_of_contents: ->
    @app.navigate 'ch2/3', trigger: true

  pinboard: ->
    @app.navigate 'pinboard', trigger: true

  calendar: ->
    @app.navigate 'ch2/2', trigger: true


  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

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
      @model.set("answer_#{counter}", @$(".#{counter}").val())
      counter++
      )
    @model.save()

  render_answers: ->
    counter = 1
    _this = @
    @$('.textarea').each( ->
      model = _this.model.get("answer_#{counter}")
      $(@).find('textarea').val(model)
      counter++
      )

  page4_model: ->
    @save_answers()

  navigate: ->
    next_page = @page += 1
    @app.navigate "ch4/#{next_page}", trigger: true

  ch5: ->
     @app.navigate "ch5/1", trigger: true

  render: ->
    @$el.html @template @model.toJSON()
