class GettingOff.Ch3 extends GettingOff.View

  className: ->
    "ch3page-#{@page}"

  constructor: (options) ->
    @page = parseInt options.page
    super

  template: (attributes) -> JST["templates/ch3/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @table_of_contents = options.table_of_contents
    @button = options.button
    @ch3_page6 = options.ch3_page6
    @avatar = options.avatar
    @validated = false
    @navbar_active = false
    @page_animation()
    @fastclick()

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @crystal_array = ["Never Use", "Sometimes Use", "Always Use"]
    @crystal_counter = 0
    @crystal_hash = {"Never Use": [], "Sometimes Use": [], "Always Use" : []}
    @sex_array =["Never Risk", "Some Risk", "Always Risk"]
    @sex_counter = 0
    @sex_hash = {"Never Risk": [], "Some Risk": [], "Always Risk": []}
    @render()

    if @page is 7
      @page6_animation()
      @play_sound()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
        @render_avatar()

    @ch3_page6.fetch
      success:(model, response, options) =>
        @ch3_page6.set model.attributes[0]
        @render_question()

    @position()

  events:
    'click .button'                     : 'navigate'
    'click .finish-chapter'             : 'ch4'
    'click .submit'                     : 'validation'
    'click .arrow.right.crystal'        : 'next_frequency_crystal'
    'click .arrow.left.crystal'         : 'prev_frequency_crystal'
    'click .arrow.right.sex'            : 'next_frequency_sex'
    'click .arrow.left.sex'             : 'prev_frequency_sex'
    'click .list'                       : 'list_handler'
    'focus .input-value'                : 'focus_handler'
    'focusout .input-value'             : 'focusout_handler'
    'focus .textarea textarea'          : 'check_validation'
    'focusout .textarea textarea'       : 'textarea_out_handler'
    'mousedown .button, .finish-chapter': 'mousedown_effect'
    'click .calendar'                   : 'calendar'
    'click .table'                      : 'go_to_table_of_contents'
    'click .user'                       : 'user'
    'click .pin'                        : 'pinboard'
    'click .previous'                   : 'previous'
    'click .list.y'                     : 'validate'
    'click .list.n'                     : 'invalidate'
    'click .save-model'                 : 'save_model'
    'click .points'                     : 'open_navbar'

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

  open_navbar: ->
    if @navbar_active is false 
      @$('footer').css('z-index', '9999')
      if $(window).width() < 768
        @$('.middle-container').animate({'bottom':'120px'}, 1000)
      else
        @$('.middle-container').animate({'bottom': '200px'}, 1000)
        
      @$('footer').show 'slide',{direction: 'down'}, 1000
      @navbar_active = true
    else 
      @$('footer').hide 'slide',{direction: 'down'}, 1000
      @$('.middle-container').animate({'bottom': '0px'}, 1000)
      @navbar_active = false

  save_model: ->
    answer = @$(".textarea textarea").val()
    @ch3_page6.set('answer', answer)

  play_sound: ->
    bell_chime = new buzz.sound("/sounds/bell_chime.mp3")
    bell_chime.play()
    # bell_chime = new Media('/sounds/bell_chime.mp3')
    # bell_chime.play()
   
  render_question: ->
    answer = @ch3_page6.get('answer')
    console.log answer
    @$('.textarea textarea').val(answer)

  invalidate: ->
    @validation = false

  check_validation: (e) ->
    target = $(e.currentTarget)
    if @validated is true
      @textarea_handler()
    else
      target.blur()
      alert "You must select YES"

  validate: ->
    @validated = true

  previous: ->
    window.history.go(-1)

  page6_animation: ->
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
     $('.score').text('600')
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

  user: ->
    @app.navigate 'new', trigger: true

  go_to_table_of_contents: ->
    @app.navigate 'ch2/3', trigger: true
    console.log 'work?'

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
    @$('.button, .finish-chapter').addClass('shrunk')

  render_button: ->
    @$('.button, .finish-chapter').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}") 
     
  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 3})
    model.set('page', @page)
    model.save()

  add_trigger_crystal: -> 
    input = @display_trigger()
    if @crystal_counter == 0 
       @crystal_hash["Never Use"].push(input)
     else if @crystal_counter == 1 
       @crystal_hash["Sometimes Use"].push(input)
     else
       @crystal_hash["Always Use"].push(input)
  
   add_trigger_sex: -> 
    input = @display_trigger()
    if @sex_counter == 0 
       @sex_hash["Never Risk"].push(input)
     else if @sex_counter == 1 
       @sex_hash["Some Risk"].push(input)
     else
       @sex_hash["Always Risk"].push(input)

  display_trigger: ->
    @$('#trig-display').html("")
    element = @$('.triggers-display')
    scrollElement = document.getElementById("trig-display")
    input = @$('.input-value').val()
    element.append "<p>#{input}</p>"
    @$('.input-value').val("")
    scrollElement.scrollTop = scrollElement.scrollHeight
    return input

  validation: ->
    if @$('.input-value').val() == "" 
      alert 'You must enter a value!'
    else if @page == 3
      @add_trigger_crystal()
    else if @page == 4
      @add_trigger_sex()

  next_frequency_crystal: ->
    @empty_triggers()
    if @crystal_counter >= 2
      @crystal_counter = 0
      @append()
    else 
      @crystal_counter++
      @append()

  prev_frequency_crystal: ->
    @empty_triggers()
    if @crystal_counter <= 0
      @crystal_counter = 2
      @append()
    else
      @crystal_counter--
      @append()
  
  next_frequency_sex: ->
    @empty_triggers()
    if @sex_counter >= 2
      @sex_counter = 0
      @append_sex()
    else 
      @sex_counter++
      @append_sex() 

  prev_frequency_sex: ->
    @empty_triggers()
    if @sex_counter <= 0
      @sex_counter = 2
      @append_sex()
    else
      @sex_counter--
      @append_sex()
  
  append: ->
    @$('.frequency-text').find('p').html("#{@crystal_array[@crystal_counter]}")
    @crystal_hash["#{@crystal_array[@crystal_counter]}"].forEach( (entry) -> 
         $('.triggers-display').append("<p>#{entry}</p>")
       )

  append_sex: ->
    @$('.frequency-text').find('p').html("#{@sex_array[@sex_counter]}")
    @sex_hash["#{@sex_array[@sex_counter]}"].forEach( (entry)->
         $('.triggers-display').append("<p>#{entry}</p>")
       )

  list_handler: (e)-> 
    target = $(e.currentTarget)
    target.siblings().removeClass('grown')
    target.siblings().removeClass('green')
    target.addClass('grown')
    target.addClass('green')
    target.find('span').css('color','white')

  focus_handler: ->
    @$('.input-value').addClass('textarea-click')

  focusout_handler: ->
    @$('.input-value').removeClass('textarea-click')

  textarea_out_handler: ->
    @$('.textarea textarea').removeClass('textarea-click')
 
  textarea_handler: ->
    @$('.textarea textarea').toggleClass('textarea-click')

  empty_triggers: ->
      $('.triggers-display').empty()

  navigate: ->
    next_page = @page+1
    @app.navigate "ch3/#{next_page}", trigger: true
  
  ch4: ->
    @app.navigate 'ch4/1', trigger: true

  render: ->
    @$el.html @template @ch3_page6.toJSON()