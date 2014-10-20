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
    @always_sex = options.always_sex
    @sometimes_sex = options.sometimes_sex
    @never_sex = options.never_sex
    @always_crystal = options.always_crystal
    @sometimes_crystal = options.sometimes_crystal
    @never_crystal = options.never_crystal
    @validated = false
    @navbar_active = false
    @current_select = ""
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

    @always_sex.fetch
      success:(model, response, options) =>


    @sometimes_sex.fetch
      success:(model, response, options) =>


    @never_sex.fetch
      success:(model, response, options) =>


    @always_crystal.fetch
      success:(model, response, options) =>


    @sometimes_crystal.fetch
      success:(model, response, options) =>


    @never_crystal.fetch
      success:(model, response, options) =>
        

    @position()

  events:
    'click .button'                     : 'navigate'
    'click .finish-chapter'             : 'ch4'
    'click .submit'                     : 'update_collection'
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
    'click .add-button'                 : 'open_input'
    'click .close'                      : 'close_input'

  determine_collection: ->
    collection = ""
    collection = switch @current_select
      when "always_sex"       then  @always_sex
      when "sometimes_sex"    then  @sometimes_sex
      when "never_sex"        then  @never_sex
      when "always_crystal"   then  @always_crystal
      when "sometimes_crystal"then  @sometimes_crystal
      when "never_crystal"    then  @never_crystal

    collection

  update_collection:  ->
    input = @$('.input-value').val()
    collection = @determine_collection()
    model = new GettingOff.Ch3_Page3_4 "scenario" : input
    collection.create(model)
    @update_text_display(input)

  update_text_display: (input) ->
    @$('.text-display').append("<p style='display: none'>#{input}</p>")
    @$('.text-display p').fadeIn(1000)
    scrollElement = document.getElementById("trig-display")
    scrollElement.scrollTop = scrollElement.scrollHeight
    @$('.input-value').val(" ")

  render_scenarios: ->
    collection = @determine_collection()
    @$('.text-display').empty()
    collection.each( (model) ->
      @$('.text-display').append "<p>#{model.get('scenario')}</p>"
      )

  close_input: ->
    @$('.general-overlay').fadeOut(1000)
    @$('.input-container').hide 'slide', {direction: 'down'}, 1000
    @$('.category-overlay').hide 'slide', {direction: 'up'}, 1000

  open_input: (e) ->
    @$('.general-overlay').fadeIn(1000)
    frequency = $(e.currentTarget).data('frequency')
    instruction = $(e.currentTarget).data('subtitle')
    @$('.instruction-subtitle').text(instruction)
    @current_select = frequency
    @render_scenarios()
    @set_category_color()
    @$('.input-container').show 'slide', {direction: 'down'}, 1000
    @$('.category-overlay').show 'slide', {direction: 'up'}, 1000
    @start_scroll_effect()

  set_category_color: ->
    color = ""
    color = switch @current_select
      when "always_sex"       then  '#E25575'
      when "sometimes_sex"    then  '#9955E2'
      when "never_sex"        then  '#5577E2'
      when "always_crystal"   then  '#E25575'
      when "sometimes_crystal"then  '#9955E2'
      when "never_crystal"    then  '#5577E2'

    @$('.category-overlay, .text-display').css('background-color', color)


  start_scroll_effect: ->
    stroll.bind('.text-display ul')

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
    @app.navigate 'ch2/4', trigger: true
    console.log 'work?'

  pinboard: ->
    @app.navigate 'pinboard', trigger: true

  calendar: ->
    @app.navigate 'ch2/3', trigger: true

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
    element = @$('.triggers-display')
    scrollElement = document.getElementById("trig-display")
    input = @$('.input-value').val()
    element.append "<p>#{input}</p>"
    @$('.input-value').val("")
    scrollElement.scrollTop = scrollElement.scrollHeight
    return input

  # validation: ->
  #   if @$('.input-value').val() == "" 
  #     alert 'You must enter a value!'
  #   else if @page == 3
  #     @add_trigger_crystal()
  #   else if @page == 4
  #     @add_trigger_sex()
  
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