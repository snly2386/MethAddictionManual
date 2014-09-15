class GettingOff.Ch2 extends GettingOff.View

  className: ->
    "ch2page_#{@page}"

  constructor: (options) ->
    @page = parseInt options.page
    @date = new Date()
    super

  template: -> JST["templates/ch2/#{@page}"]

  initialize: (options) ->
    @app = options.app
    @table_of_contents = options.table_of_contents
    @button = options.button
    @table_of_contents.fetch
      success:(model, response, options) =>
        @render_table_of_contents()

    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @month_index = @date.getMonth()
    @month = months[@month_index]
    @year = @date.getFullYear()

    @load_page()
    @render()
    if @page is 2
      @get_calendar()
      
    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()
    @set_date()

    @render_table_of_contents()
    @practice = {}
    @practice["#{@month}" + "#{@year}"] = @$('.calendar').html()

  events: 
    'click .button'                      : 'navigate'
    'click .finish-chapter'              : 'ch3'
    'click .pins .pin'                   : 'pin_color'
    'click .next'                        : 'next_month'
    'click .back'                        : 'prev_month'
    'click .finish-chapter'              : 'ch3'
    'mousedown .button, .finish-chapter' : 'mousedown_effect'
    'click .user'                        : 'finish_setup'
    'click .table'                       : 'go_to_table_of_contents'
    'click .calendar'                    : 'calendar'
    # 'click h1'                           : 'load_page'

  load_page: ->
        @$el.addClass('animated')
        @$el.addClass('lightSpeedIn')

  calendar: ->
    @app.navigate 'ch2/2', trigger: true

  go_to_table_of_contents: ->
    @app.navigate 'ch2/3', trigger: true

  finish_setup: ->
    @app.navigate 'finish_setup', trigger: true

  mousedown_effect: ->
    @$('.button, .finish-chapter').addClass('shrunk')

  mouseup_effect: ->
    @$('.button, .finish-chapter').removeClass('shrunk')

  get_calendar: ->
    date = new Date()
    first_day = new Date(date.getFullYear(), date.getMonth(), 1)
    day_index = first_day.getDay()
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    day = days[day_index]

    counter = 1
    day_html = ""
    number_of_days = new Date(@year, @month_index, 0).getDate()

    @$('.first').each(->
      if $(@).data('day') is day
        day_html = $(@)
      )

    @$('.date')[day_html.index()..(day_html.index() + number_of_days-1)].each( ->
        $(@).html(counter)
        counter++
      )

  render_button: ->
    @$('.button, .finish-chapter').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")   

  render_table_of_contents: ->
    table_of_contents = @table_of_contents
    @$('.chapter').each( ->
      model = table_of_contents.findWhere({chapter: parseInt("#{$(@).data('chapter')}")})
      percentage = model.percentage()
      console.log percentage
      if percentage is 100
        $(@).append("<img src='assets/progress_check.png'/>")
        $(@).addClass('session-complete')
      else 
        $(@).parent('.paragraph').append("<div class='progress #{$(@).data('chapter')}' style='width:0px'></div>")
        $(".progress.#{$(@).data('chapter')}").animate({width: "#{percentage}%"}, 2000)
      )

  next_month: ->
    if @month_index == 11
      @month_index = 0
      @year += 1
    else
      @month_index += 1
    @set_month()
    @populate_calendar()

  prev_month: ->
    if @month_index == 0
      @month_index = 11
      @year -= 1
    else
      @month_index -=1
    
    @set_month()
    @reverse_calendar()

  reverse_calendar: ->
    year = @year
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    month = months[@month_index]
    number_of_days = ""
    
    number_of_days = switch month
      when "January"  then  31
      when "February" then  28
      when "March"    then  31
      when "April"    then  30
      when "May"      then  31
      when "June"     then  30
      when "July"     then  31
      when "August"   then  31
      when "September"then  30
      when "October"  then  31
      when "November" then  30
      when "December" then  31

    for yearr in [2000..3000] by 4
      if year is yearr && month is "February"
        number_of_days = 29

    # @$('.calendar').html(@practice["#{month}" + "#{@year}"])
    empty_slots = []
    results = []
    last_day = ""
    @$('.first').each( ->
      if $(@).html() is ""
        empty_slots.push $(@).data('day')
      )

    if empty_slots.length is 0
      last_day = "sunday"
    else 
      last_day = empty_slots[empty_slots.length-1]


    days = ["monday","tuesday","wednesday","thursday","friday","saturday", "sunday","monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
    
    i = 0
    while i < days.length
      results.push i  if days[i] is last_day
      i++

    day_index = results[1] 
    first_day_remainder = (((number_of_days-1) / 7) % 1).toPrecision(4)

    first_day_subtract = switch first_day_remainder
      when '0.000'  then 0 
      when '0.1429' then 1 
      when '0.2857' then 2
      when '0.4286' then 3
      when '0.5714' then 4
      when '0.7143' then 5
      when '0.8571' then 6
    console.log "FIRST_DAY_SUBTRACT: #{first_day_subtract}"
    first_day_index = day_index - first_day_subtract
    first_day = days[first_day_index]
    console.log "FIRST_DAY: #{first_day}"
    first_day_html = ""
    counter = 1

    @$('.first').each( ->
      if $(@).data('day') is first_day
        first_day_html = $(@)
      )
  

    @$('.date')[first_day_html.index()..(first_day_html.index() + number_of_days-1)].each( ->
        $(@).html(counter)
        counter++
        )

    @$('.date')[0...first_day_html.index()].each( ->
        $(@).empty()
        )

    remaining_days = first_day_html.index() + number_of_days-1
    @$('.date')[remaining_days + 1..41].empty()

  populate_calendar: ->
    year = @year
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    month = months[@month_index]
    number_of_days = ""
  
    number_of_days = switch month
      when "January"  then  31
      when "February" then  28
      when "March"    then  31
      when "April"    then  30
      when "May"      then  31
      when "June"     then  30
      when "July"     then  31
      when "August"   then  31
      when "September"then  30
      when "October"  then  31
      when "November" then  30
      when "December" then  31

    for yearr in [2000..3000] by 4
      if @year is yearr && month is "February"
        number_of_days = 29
        console.log yearr
        console.log 'WTFFF'

    first_day = ""
    new_array = []
    counter = 1
    @$('.what').each( ->
        if $(@).html() is ""
          new_array.push $(@).data('day')
      ) 

    if new_array.length is 0
      @$('.extra').each( ->
        if $(@).html() is ""
          new_array.push $(@).data('day')
        )

    @$('.first').each( ->
        if $(@).data('day') == new_array[0]
          first_day = $(@)
      )

    @$('.date')[first_day.index()..(first_day.index() + number_of_days-1)].each( ->
      $(@).html(counter)
      counter++
      )

    @$('.date')[0...first_day.index()].each( ->
      $(@).empty()
      )

    remaining_days = first_day.index() + number_of_days-1
    @$('.date')[remaining_days + 1..41].empty()

    @practice["#{month}" + "#{@year}"] = @$('.calendar').html()


  pin_color: (e) ->
     target = @$(e.currentTarget)
     if target.data('color') == "white" && target.hasClass('1terday')
        # @$(".block.11, .block.1").addClass("white")
        @$('.top-container.15').addClass("white-color")
        @$('.top-container.15').removeClass("red-color")
        @$('.top-container.15').removeClass("blue-color")
        @clear_calendar(target)
     else if target.data('color') == "white" && target.hasClass('2day')
        # @$(".block.22, .block.2").addClass("white")
        @$(".top-container.16").addClass("white-color")
        @$('.top-container.16').removeClass("red-color")
        @$('.top-container.16').removeClass("blue-color")
        @clear_calendar(target)
     else if target.data('color') == "white" && target.hasClass('2morrow')
        # @$(".block.33, .block.3").addClass("white")
        @$(".top-container.17").addClass("white-color")
        @$('.top-container.17').removeClass("red-color")
        @$('.top-container.17').removeClass("blue-color")
        @clear_calendar(target)
     else if target.hasClass('1terday') && target.data('color') is 'blue'
        @$(".top-container.15").removeClass("white-color")
        @$(".top-container.15").addClass("blue-color")
        @update_calendar(target)
     else if target.hasClass('2day') && target.data('color') is 'blue'
        @$(".top-container.16").removeClass("white-color")
        @$(".top-container.16").addClass("blue-color") 
        @update_calendar(target)
     else if target.hasClass('2morrow') && target.data('color') is 'blue'
        @$(".top-container.17").removeClass("white-color")
        @$(".top-container.17").addClass("blue-color")
        @update_calendar(target)
     else if target.hasClass('1terday') && target.data('color') is 'red'
        @$(".top-container.15").removeClass('white-color').addClass('red-color')
     else if target.hasClass('2day') && target.data('color') is 'red'
        @$(".top-container.16").removeClass('white-color').addClass('red-color')
     else if target.hasClass('2morrow') && target.data('color') is 'red'
        @$(".top-container.17").removeClass('white-color').addClass('red-color')


  update_calendar: (target) ->
    classname = target.data('tag')
    value = @$("#{classname}").html()
    @$(".date").each( ->
      if $(@).html() == value
        $(@).addClass('red')
      )

  clear_calendar: (target) ->
    classname = target.data('tag')
    value = @$("#{classname}").html()
    @$(".date").each( ->
      if $(@).html() == value
        $(@).removeClass('red')
      )

  set_month: ->
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
    year = @year
    @$('header h1').html(months[@month_index] + " #{year}")

  set_date: ->
    date = @date.getDate()
    @$(".day .num.todayy").html(date)
    @$(".day .num.yesterday").html(date - 1)
    @$(".day .num.tomorrow").html(date + 1)
    # @set_day()
    @set_month()

  set_day: ->
    days = ["", "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    day = @date.getDay()
    if day is 1
      yesterday = 7
    else
      yesterday = day - 1

    if day is 7
      tomorrow = 1
    else 
      tomorrow = day + 1
    @$(".day .dayofweek-today").html(days[day])
    @$(".day .dayofweek-yesterday").html(days[yesterday])
    @$(".day .dayofweek-tomorrow").html(days[tomorrow])

  ch3: ->
    @app.navigate "ch3/1", trigger: true

  render: ->
    @$el.html @template()

  navigate: ->
    next_page = @page + 1
    @app.navigate "ch2/#{next_page}", trigger: true
