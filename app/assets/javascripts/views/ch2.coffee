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
    @table_of_contents.fetch
      success:(model, response, options) =>
        @render_table_of_contents()

    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @month_index = @date.getMonth()
    @month = months[@month_index]
    @year = @date.getFullYear()

    @render()
    @position()
    @set_date()

    @render_table_of_contents()
    @practice = {}
    @practice["#{@month}" + "#{@year}"] = @$('.calendar').html()

  events: 
    'click .button'         : 'navigate'
    'click .finish-chapter' : 'ch3'
    'click .pins .pin'      : 'pin_color'
    'click .next'           : 'next_month'
    'click .back'           : 'prev_month'
    'click .finish-chapter' : 'ch3'

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
    year = @year
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    month = months[@month_index]
    number_of_days = ""
    for yearr in [2016..3000] by 4
      if @year is year && month is "February"
        number_of_days = 29
      else
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

    # if (@year is 2016 || @year is 2020 || @year is 2024 || @year is 2028) && month is "February" 
    #   number_of_days = 29

    console.log month  
    console.log @year
    console.log number_of_days
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

    # if @calendars.indexOf(@$('.calendar').html()) is -1
    #     @calendars.push @$('.calendar').html()
    # else
    #     console.log 'already pushed that shit'
    # console.log @calendars.length

  pin_color: (e) ->
     target = @$(e.currentTarget)
     if target.data('color') == "white" && target.hasClass('1terday')
        @$(".block.11, .block.1").addClass("white")
        # @$(".block.11").addClass('blue')
        @clear_calendar(target)
     else if target.data('color') == "white" && target.hasClass('2day')
        @$(".block.22, .block.2").addClass("white")
        @$(".block.22").addClass('blue')
        @clear_calendar(target)
     else if target.data('color') == "white" && target.hasClass('2morrow')
        @$(".block.33, .block.3").addClass("white")
        @$(".block.33").addClass("blue")
        @clear_calendar(target)
     else if target.hasClass('1terday') && @$(".block.11").hasClass("one")
        @$(".block.11, .block.1").removeClass("white")
        @$(".block.11, .block.1").removeClass("blue")
        @$(".block.1").css("background-color", "#{target.data('color')}")
        @update_calendar(target)
     else if target.hasClass('2day') && @$(".block.22").hasClass("one")
        @$(".block.22, .block.2").removeClass("white")
        @$(".block.22, .block.2").removeClass("blue")
        @$(".block.2").css("background-color", "#{target.data('color')}")
        @update_calendar(target)
     else if target.hasClass('2morrow') && @$(".block.33").hasClass("one")
        @$(".block.33, .block.3").removeClass("white")
        @$(".block.33, .block.3").removeClass("blue")
        @$(".block.3").css("background-color", "#{target.data('color')}")
        @update_calendar(target)
     else if target.hasClass("1terday")
        @$(".block.11, .block.1").removeClass("white")
        @$(".block.11, .block.1").removeClass("blue")
        @$(".block.11").css("background-color", "#{target.data('color')}" )
        @$(".block.11").addClass("one")
        @update_calendar(target)
     else if target.hasClass("2day")
        @$(".block.22, .block.2").removeClass("white")
        @$(".block.22, .block.2").removeClass("blue")
        @$(".block.22").css("background-color", "#{target.data('color')}" )
        @$(".block.22").addClass("one")
        @update_calendar(target)
     else if target.hasClass("2morrow")
        @$(".block.33, .block.3").removeClass("white")
        @$(".block.33, .block.3").removeClass("blue")
        @$(".block.33").css("background-color", "#{target.data('color')}" )
        @$(".block.33").addClass("one")
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
