class GettingOff.Ch1 extends GettingOff.View

  id: -> "ch1"
  
  className: ->
    "page_#{@page}"

  constructor: (options) ->
    @page = parseInt options.page
    super

  template: -> JST["templates/ch1/#{@page}"] 

  initialize: (options) ->
    @app = options.app
    @button = options.button


    @validation = false

    @chapters = [0..13]

    @load_page()
    @render()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()
    
    if @page != 13
      @scroll_to_bottom()

  events: 
    'click .rating'                       : 'rate_question'
    'click .button'                       : 'navigate'
    'click .ch1-finish-button'            : 'ch2'
    'mousedown .button, .finish-chapter'  : 'mousedown_effect'
    'mouseup .button'                     : 'mouseup_effect'

  scroll_to_bottom: ->
    # scrollElement = document.getElementById("mid-container")
    # scrollElement.scrollTop = scrollElement.scrollHeight
    scrollElement = document.getElementById("mid-container")
    target = $('#mid-container')
    $('#mid-container').animate({scrollTop: scrollElement.scrollHeight}, 3000)

  load_page: ->
    $('body').css('display', 'none')
    $('body').fadeIn(1000)

  mousedown_effect: ->
    @$('.button, .finish-chapter').addClass('shrunk')

  mouseup_effect: ->
    @$('.button').removeClass('shrunk')

  render_button: ->
    @$('.button, .finish-chapter').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")   

  rate_question: (e)->
    target = $(e.currentTarget)
    if target.hasClass 'border'
      target.removeClass('border')
      @$('.description').empty()
      @validation = false
    else 
      target.addClass('border')
      target.siblings().removeClass('border')
      @$('.description').hide()
      @$('.description').html target.data 'description'
      @$('.description').fadeIn(1000)
      @validation = true
      @scroll_to_bottom()

  navigate: ->
    next_chapter = @page + 1

    if @page is _(@chapters).last() 
      @app.navigate "ch3/1", trigger: true
    else if @validation == true
      @app.navigate "ch1/#{next_chapter}", trigger: true
    else if @cordova is true
      # validation failed
      notification.alert 'You must enter a value'
    else
      alert 'You must enter a value'

  ch2: ->
    @app.navigate "ch2/1", trigger: true

  render: ->
    @$el.html @template()

  # add_description: (target) ->
  #   position = $('.ch1-rate-description')
  #   switch target.data('value')
  #     when '1' then position.html target.data('description')
  #     when '2' then position.html target.data('description')
  #     when '3' then position.html target.data

 


