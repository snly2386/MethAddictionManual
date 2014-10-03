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
    @button = options.button
    @avatar = options.avatar

    @page_animation()

    @table_of_contents = options.table_of_contents

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()
    
    @model.fetch
      success: (model, response, options) =>
        @model.set model.attributes[0]
        @render()
        @position()

    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
        @render_avatar()

    @names.fetch
      success:(model, response, options) =>
        @render_names()

    if @page is 6
      @point_animation()

    if @page is 2 || @page is 4
      @scroll_to_bottom()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @make_draggable()

  events: ->
    'click .button'                                    : 'navigate'
    'focus .textarea textarea'                         : 'focus_handler'
    'focusout .textarea textarea'                      : 'focusout_handler'
    'click .save-answers'                              : 'save_answers'
    'click .add-name'                                  : 'popup_menu'
    'click .submit'                                    : 'create_person'
    'click .float-shadow'                              : 'float_effect'
    'click .finish-chapter'                            : 'ch6'
    'mousedown .button, .finish-chapter, .save-answers': 'mousedown_effect'
    'mouseup .button, .finish-chapter, .save-answers'  : 'mouseup_effect'
    'click .calendar'                                  : 'calendar'
    'click .table'                                     : 'go_to_table_of_contents'
    'click .user'                                      : 'user'
    'click .pin'                                       : 'pinboard'
    'mousedown .circle'                                : 'bring_to_front'
    'click .previous'                                  : 'previous'
    'click .tooltip'                                   : 'open_tooltip'
    'click .speech-container'                          : 'close_tooltip'

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

  scroll_to_bottom: ->
    scrollElement = document.getElementById("mid-container")
    scrollElement.scrollTop = scrollElement.scrollHeight/3

  close_tooltip: ->
    @$('.overlay').fadeOut(1000)
    @$('.speech-bubble').transition({width: '0px'})

  open_tooltip: ->
    @$('.overlay').fadeIn(1000)
    @$('.speech-bubble').transition({width: '50%'}, 1000)

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
     $('.score').text('1000')
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

  show_avatar: ->
    @$('.avatar-container').fadeIn(2000)

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
    $('body').css('display','none')
    $('body').fadeIn(2000)

  mousedown_effect: ->
    @$('.button, .finish-chapter, .save-answers').addClass('shrunk')

  mouseup_effect: ->
    @$('.button, .finish-chapter, .save-answers').removeClass('shrunk')

  render_button: ->
    @$('.button, .finish-chapter, .save-answers').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")

  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 5})
    model.set('page', @page)
    model.save()

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

  remove_float: ->
    @$('.float-shadow').removeClass('float-shadow-click')
    
  create_person: ->
    person = @$('.name').val()
    color_data = @$(".float-shadow-click").data('color')
    name = new GettingOff.Ch5_Name "name" : person, "color" : color_data
    @names.create(name)
    div = "<div class='circle font-sans' style='background-color:#{color_data}'>#{person}</div>"
    @append(div)
    @$(".popup-menu").hide 'slide', {direction: 'down'}, 1000
    @remove_float()
    @make_draggable()

  append: (div)->
    $('.web .me').append(div)

  bring_to_front: (e) ->
    target = $(e.currentTarget)
    $('.circle').removeClass('border-effect')
    $('.circle').css({'z-index':'0', 'opacity' : '0.5'})
    target.css({'z-index': '100', 'opacity' : '1'})
    target.addClass('border-effect')
    @make_draggable()

  render_names: ->
    @names.each (model) ->
      random = Math.floor((Math.random() * 7) + 1)
      random_80 = Math.floor((Math.random() * 80) + 1) 
      $('.web .me').append("<div class='circle font-sans' style='background-color: #{model.get('color')}; margin-top: -#{random}%; left: #{random_80}%;'>#{model.get('name')}</div>")
    
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

  ch6: ->
    @app.navigate "ch6/1", trigger: true

  render: ->
    @$el.html @template @model.toJSON()