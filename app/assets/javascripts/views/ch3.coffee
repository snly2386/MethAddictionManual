class GettingOff.Ch3 extends GettingOff.View

  className: ->
    "ch3page-#{@page}"

  constructor: (options) ->
    @page = parseInt options.page
    super

  template: -> JST["templates/ch3/#{@page}"]

  initialize: (options) ->
    @app = options.app
    @table_of_contents = options.table_of_contents
    @button = options.button
    @page_animation()

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @crystal_array = ["Never Use", "Sometimes Use", "Always Use"]
    @crystal_counter = 0
    @crystal_hash = {"Never Use": [], "Sometimes Use": [], "Always Use" : []}
    @sex_array =["Never High-Risk", "Some High-Risk", "Always High-Risk"]
    @sex_counter = 0
    @sex_hash = {"Never High-Risk": [], "Some High-Risk": [], "Always High-Risk": []}
    @render()

    if @page is 6
      @page6_animation()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

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
    'focus .textarea textarea'          : 'textarea_handler'
    'focusout .textarea textarea'       : 'textarea_out_handler'
    'mousedown .button, .finish-chapter': 'mousedown_effect'
    'click .calendar'                   : 'calendar'
    'click .table'                      : 'go_to_table_of_contents'
    'click .user'                       : 'user'
    'click .pin'                        : 'pinboard'
    'click .previous'                   : 'previous'

  previous: ->
    window.history.go(-1)

  page6_animation: ->
    window.setTimeout (->
     $(".overlay").fadeIn(1000)
     $(".points-container").jrumble x: 10, y: 10, rotation: 4
     $(".points-container").trigger("startRumble")
     return
  ), 2000

    window.setTimeout (->
     $('.score').animate({'color':'red'}, 3000)
     $('.points').animate({'color':'red'}, 3000)
     return 
  ), 3000

    window.setTimeout (->
     $(".points-container").trigger("stopRumble")
     $(".points-container").addClass('hung')
     $('.score').animate({'color':'rgb(0, 143, 255)'}, 2000)
     $('.points').animate({'color':'rgb(0, 143, 255)'}, 2000) 
     return
  ), 6000

    window.setTimeout (->
     $('.points-container p').addClass('animated')
     $('.points-container p').addClass('rollOut')
     return
  ), 10000

    window.setTimeout (-> 
     $('.overlay').animate({'background-color': 'white', "opacity":"1"},3000)
     $('.overlay').css('z-index', '1000')
     $('.score').css('color', 'white')
     $('.points').css({'color': 'white', 'z-index' : '0'})
     $('.points-container').removeClass('hung')
     return
  ), 11000

    window.setTimeout (->
     $('.points-container p').removeClass('animated')
     $('.points-container p').removeClass('rollOut')
     $(".score").html("600")
     $(".points").css('color', 'rgb(39, 248, 11)')
     $(".points-container").fadeIn(4000)
     $(".overlay").fadeOut(1000)
     return
  ), 15000
   

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
       @sex_hash["Never High-Risk"].push(input)
     else if @sex_counter == 1 
       @sex_hash["Some High-Risk"].push(input)
     else
       @sex_hash["Always High-Risk"].push(input)

  display_trigger: ->
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
    else if @page == 2
      @add_trigger_crystal()
    else if @page == 3
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
    @$el.html @template()