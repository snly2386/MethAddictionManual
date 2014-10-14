class GettingOff.Ch7 extends GettingOff.View

  className: ->
    "ch7page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: -> JST["templates/ch7/#{@page}"]

  initialize: (options) ->
    @app = options.app
    @table_of_contents = options.table_of_contents
    @button = options.button
    @page_animation()

    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @render()

    if @page is 7
      @point_animation()
      @play_sound()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()

  events: 
    'click .button'                      : 'navigate'
    'click .finish-chapter'              : 'ch8'
    'mousedown .button, .finish-chapter' : 'mousedown_effect'
    'click .calendar'                    : 'calendar'
    'click .table'                       : 'go_to_table_of_contents'
    'click .user'                        : 'user'
    'click .pin'                         : 'pinboard'
    'click .previous'                    : 'previous'

  play_sound: ->
    bell_chime = new buzz.sound("/sounds/bell_chime.mp3")
    bell_chime.play()

  point_animation: ->
    window.setTimeout (->
     $(".overlay").fadeIn(1000)
     # $(".points-container").jrumble x: 10, y: 10, rotation: 4
     # $(".points-container").trigger("startRumble")
     return
  ), 2000

    window.setTimeout (->
     # $('.score').animate({'color':'red'}, 3000)
     # $('.points').animate({'color':'red'}, 3000)
     $('.points-container').addClass('animated')
     $('.points-container').addClass('rollOut')
     return 
  ), 3000

    window.setTimeout (->
     # $('.points-container').hide()
     $('.score').text('1400')
     return 
  ), 4000

    window.setTimeout (->
     # $('.points-container').show()
     $('.points-container').removeClass('rollOut')
     $('.points-container').addClass('bounceInDown')
     $('.overlay').fadeOut(3000)
     return 
  ), 5000  

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
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  mousedown_effect: ->
    @$('.button, .finish-chapter').addClass('shrunk')

  mouseup_effect: ->
    @$('.button, .finish-chapter').removeClass('shrunk')

  render_button: ->
    @$('.button, .finish-chapter, .page2-model, .page9-model').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")
  

  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 7})
    model.set('page', @page)
    model.save()

  ch8: ->
    @app.navigate "ch8/1", trigger: true

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch7/#{next_chapter}", trigger: true

  render: ->
    @$el.html @template()