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
    #@pages = [0..]
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @month_index = @date.getMonth()
    @month = months[@month_index]
    @year = @date.getFullYear()

    @render()
    @position()
    @set_date()
    # @calendars = []
    @practice = {}
    @practice["#{@month}" + "#{@year}"] = @$('.calendar').html()
    # @calendars.push $('.calendar').html()
    # @populate_calendar()

  events: 
    'click .button'         : 'navigate'
    'click .finish-chapter' : 'ch3'
    'click .pins .pin'      : 'pin_color'
    'click .next'           : 'next_month'
    'click .back'           : 'prev_month'

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

    if @month_index == 8 && @year == 2014
      alert "FUCK OFF"
    else 
      @reverse_calendar()

  reverse_calendar: ->
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    month = months[@month_index]
    # index = @calendars.indexOf(@$('.calendar').html())
    # console.log index
    # @$('.calendar').html(@calendars[index-1])
    if month is "September" && @year is 2014
      alert "Can't go back any further"
    else 
      @$('.calendar').html(@practice["#{month}" + "#{@year}"])

  populate_calendar: ->
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
    console.log @practice

    # if @calendars.indexOf(@$('.calendar').html()) is -1
    #     @calendars.push @$('.calendar').html()
    # else
    #     console.log 'already pushed that shit'
    # console.log @calendars.length

  pin_color: (e) ->
     target = @$(e.currentTarget)
     if target.data('color') == "white" && target.hasClass('1terday')
        @$(".today.1, .block.1").addClass("white")
        @$(".today.1").addClass('blue')
        @clear_calendar(target)
     else if target.data('color') == "white" && target.hasClass('2day')
        @$(".today.2, .block.2").addClass("white")
        @$(".today.2").addClass('blue')
        @clear_calendar(target)
     else if target.data('color') == "white" && target.hasClass('2morrow')
        @$(".today.3, .block.3").addClass("white")
        @$(".today.3").addClass("blue")
        @clear_calendar(target)
     else if target.hasClass('1terday') && @$(".today.1").hasClass("one")
        @$(".today.1, .block.1").removeClass("white")
        @$(".today.1, .block.1").removeClass("blue")
        @$(".block.1").css("background-color", "#{target.data('color')}")
        @update_calendar(target)
     else if target.hasClass('2day') && @$(".today.2").hasClass("one")
        @$(".today.2, .block.2").removeClass("white")
        @$(".today.2, .block.2").removeClass("blue")
        @$(".block.2").css("background-color", "#{target.data('color')}")
        @update_calendar(target)
     else if target.hasClass('2morrow') && @$(".today.3").hasClass("one")
        @$(".today.3, .block.3").removeClass("white")
        @$(".today.3, .block.3").removeClass("blue")
        @$(".block.3").css("background-color", "#{target.data('color')}")
        @update_calendar(target)
     else if target.hasClass("1terday")
        @$(".today.1, .block.1").removeClass("white")
        @$(".today.1, .block.1").removeClass("blue")
        @$(".today.1").css("background-color", "#{target.data('color')}" )
        @$(".today.1").addClass("one")
        @update_calendar(target)
     else if target.hasClass("2day")
        @$(".today.2, .block.2").removeClass("white")
        @$(".today.2, .block.2").removeClass("blue")
        @$(".today.2").css("background-color", "#{target.data('color')}" )
        @$(".today.2").addClass("one")
        @update_calendar(target)
     else if target.hasClass("2morrow")
        @$(".today.3, .block.3").removeClass("white")
        @$(".today.3, .block.3").removeClass("blue")
        @$(".today.3").css("background-color", "#{target.data('color')}" )
        @$(".today.3").addClass("one")
        @update_calendar(target)

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
