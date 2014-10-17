class GettingOff.Ch8 extends GettingOff.View

  className: ->
    "ch8page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: (attributes) -> JST["templates/ch8/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @page6_model = options.page6_model
    @table_of_contents = options.table_of_contents
    @button = options.button
    @avatar = options.avatar
    @page_animation()
    @fastclick()

    @page6_model.fetch
      success:(model, response, options) =>
        @page6_model.set model.attributes[0]


    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @render()

    if @page is 8
      @point_animation()
      @play_sound()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
        @render_avatar()
        
    @position()

  events: 
    'click .button'                      : 'navigate'
    'click .list p'                      : 'add_check'
    'click .finish-chapter'              : 'ch9'
    'mousedown .button, .finish-chapter' : 'mousedown_effect'
    'mouseup .button, .finish-chapter'   : 'mouseup_effect'
    'click .calendar'                    : 'calendar'
    'click .table'                       : 'go_to_table_of_contents'
    'click .user'                        : 'user'
    'click .pin'                         : 'pinboard'
    'click .previous'                    : 'previous'
    'click .ch8-model'                    : 'page6_save'

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
     $('.score').text('1600')
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
    @$('.button, .finish-chapter, .page2-model, .page9-model').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")
  
  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 8})
    model.set('page', @page)
    model.save()


  add_check: (e) ->
    target = @$(e.currentTarget)
    if target.hasClass('click-list')
      target.removeClass('click-list')
      console.log target
      console.log target.find('img')
      target.find('img').remove()
    else
      target.addClass('click-list')
      target.prepend("<img src='assets/progress_check.png'/>")

  page6_save: ->
    counter = 1
    @$('.textarea').each( =>
        @page6_model.set("question_#{counter}", $(".#{counter}").val())
        counter++
      )
    @page6_model.save()
    @navigate()

  ch9:->
    @app.navigate "ch9/1", trigger: true

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch8/#{next_chapter}", trigger: true

  render: ->
    @$el.html @template @page6_model.toJSON()