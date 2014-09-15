class GettingOff.Ch1 extends GettingOff.View

  id: 'ch1'
  
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

  events: 
    'click .rating'                       : 'rate_question'
    'click .button'                       : 'navigate'
    'click .ch1-finish-button'            : 'ch2'
    'mousedown .button, .finish-chapter'  : 'mousedown_effect'
    'mouseup .button'                     : 'mouseup_effect'

  
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
    console.log @button.get('color')

  rate_question: (e)->
    target = $(e.currentTarget)
    if target.hasClass 'border'
      target.removeClass('border')
      @$('.description').empty()
      @validation = false
    else 
      target.addClass('border')
      target.siblings().removeClass('border')
      @$('.description').html target.data 'description'
      @validation = true

  navigate: ->
    next_chapter = @page + 1

    if @page is _(@chapters).last() 
      @app.navigate "ch3/1", trigger: true
    else if @validation == true
      @app.navigate "ch1/#{next_chapter}", trigger: true
    else 
      # validation failed
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

 


