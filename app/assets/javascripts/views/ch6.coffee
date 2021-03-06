class GettingOff.Ch6 extends GettingOff.View

  className: ->
    "ch6page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: (attributes) -> JST["templates/ch6/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @page2_model = options.page2_model
    @page9_model = options.page9_model
    @table_of_contents = options.table_of_contents
    @button = options.button
    @avatar = options.avatar
    @page_animation()
    @fastclick()

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @page2_model.fetch
      success:(model, response, options) =>
        @page2_model.set model.attributes[0]

    @page9_model.fetch
      success:(model, response, options) =>
        @page9_model.set model.attributes[0]


    if @page == 10
      @render_9()
    else    
      @render()

    if @page is 11
      @point_animation()
      @play_sound()
      
    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
        @render_avatar()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()

  events: 
    'click .button'                                                 : 'navigate'
    'click .finish-chapter'                                         : 'ch7'
    'click .page2-model'                                            : 'page2_save'
    'click .page9-model'                                            : 'page9_save'
    'click .title.first'                                            : 'show_problems'
    'click .title.second'                                           : 'show_what_do'
    'focus .textarea textarea'                                      : 'focus_handler'
    'focusout .textarea textarea'                                   : 'focusout_handler'
    'mousedown .button, .finish-chapter, .page2-model, .page9-model': 'mousedown_effect'
    'mouseup .button, .finish-chapter, .page2-model, .page9-model'  : 'mouseup_effect'
    'click .calendar'                                               : 'calendar'
    'click .table'                                                  : 'go_to_table_of_contents'
    'click .user'                                                   : 'user'
    'click .pin'                                                    : 'pinboard'
    'click .previous'                                               : 'previous'

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
     $('.score').text('1200')
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
    @app.navigate 'ch2/4', trigger: true 

  pinboard: ->
    @app.navigate 'pinboard', trigger: true

  calendar: ->
    @app.navigate 'ch2/3', trigger: true

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  mousedown_effect: ->
    @$('.button, .finish-chapter, .page2-model, .page9-model').addClass('shrunk')

  mouseup_effect: ->
    @$('.button, .finish-chapter, .page2-model, .page9-model').removeClass('shrunk')

  render_button: ->
    @$('.button, .finish-chapter, .page2-model, .page9-model').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")

  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 6})
    model.set('page', @page)
    model.save()

  focus_handler: (e) ->
    target = @$(e.currentTarget)
    target.addClass('textarea-click')

  focusout_handler: (e) ->
    target = @$(e.currentTarget)
    target.removeClass('textarea-click')

  show_problems: ->
    switch @page
      when 4 then problems = ["Medical Problems", "Depression", "Out-of-Control Behavior", "Contact With Triggers", "Exhaustion", "Lack of Sex Drive"]
      when 5 then problems = ["Too Much/Too Little Work", "Overconfidence", "Occasional Cravings", "Insomnia/Anxiety", "Loneliness/Boredom", "Strong Sexual Desire/Sexual Acting Out"]
      when 6 then problems = ["Sluggishnewss/Depression", "Relapse Justification for Drugs and High-Risk Sex", "Unfocused Activity", "Loneliness/Boredom", "Family Problems"]
      when 7 then problems = ["Relationship Problems", "Overconfidence", "Lack of Goals", "Job/Career Dissatisfaction", "Boredom with Sobriety", "Boredom with Sex Life"]
      when 8 then problems = ["Depression, Anger, and Guilt","Boredom","Relationship/Sexual Problems"]
      else problems = ["Medical Problems", "Depression", "Out-of-Control Behavior", "Contact With Triggers", "Exhaustion", "Lack of Sex Drive"]

    @$('.title').removeClass('title-clicked')
    @$('.title.first').addClass('title-clicked')
    @render_problems_solutions(problems)

  show_what_do: ->
    switch @page
      when 4 then solutions = ["Medical Examination", "Exercise", "Daily Visits to Therapist/12-step Meetings", "Eliminate Triggers", "Allow Time for Sleep", "Let Time Pass/Talk to Therpaist or Friend"]
      when 5 then solutions = ["Schedule Time", "Educate Yourself About Dependence", "Thought-stopping", "Exercise", "12-Step Meetings/Time with Friends", "Reasoned Action--Identify Risks and Limit Exposure to Triggers"]
      when 6 then solutions = ["Exercise", "Identifying Relapse Justifications", "Thought-stopping", "Schedule Time", "Group Involvement", "Conjoint Counseling"]
      when 7 then solutions = ["Relationship Counseling", "Group Involvement", "Goal Setting", "Vocational Counseling", "Starting New Activities", "Redefine Meaning of Sex and Sexuality"]
      when 8 then solutions = ["Exercise, Counseling, and Group Therapy", "12-step Meetings/Spend Time with Friends", "Conjoint Therapy"]
      else solutions = ["Medical Examination", "Exercise", "Daily Visits to Therapist/12-step Meetings", "Eliminate Triggers", "Allow Time for Sleep", "Let Time Pass/Talk to Therapist or Friend"]

    @$('.title').removeClass('title-clicked')
    @$('.title.second').addClass('title-clicked')
    @render_problems_solutions(solutions)

  render_problems_solutions: (list)->
    counter = 0
    @$('.list-item').each( ->
      $(@).html(list[counter])
      counter++
      )

  page2_save: ->
    counter = 1
    @$('.textarea').each( =>
        @page2_model.set("answer_#{counter}", $(".#{counter}").val())
        counter++
      )
    @page2_model.save()
    @navigate()

  page9_save: ->
    counter = 1
    @$('.textarea').each( =>
        @page9_model.set("question_#{counter}", $(".#{counter}").val())
        counter++
      )
    @page9_model.save()
    @ch7()

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch6/#{next_chapter}", trigger: true

  ch7: ->
    @app.navigate "ch7/1", trigger: true
    console.log 'ch7 bitches'

  render: ->
    @$el.html @template @page2_model.toJSON()

  render_9: ->
    @$el.html @template @page9_model.toJSON()
