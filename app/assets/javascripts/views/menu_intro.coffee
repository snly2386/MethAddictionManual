class GettingOff.Menu_Intro extends GettingOff.View

  className: -> "menu-intro" 

  template: (attributes) -> JST["templates/menu_intro"](attributes)

  initialize: (options) ->
    @app = options.app
    @button = options.button

    @page_animation()

    @render()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()

  events: ->
    'click .button'                     : 'navigate'
    'click .tooltip'                    : 'tooltip'
    'click .overlay, .message-container': 'close_tooltip'
    'click .calendar'                   : 'calendar'
    'click .table'                      : 'go_to_table_of_contents'
    'click .user'                       : 'user'
    'click .pin'                        : 'pinboard'
    'click .previous'                   : 'previous'

  render_button: ->
    @$('.button, .finish-chapter, .save-answers').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}") 

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

  close_tooltip: ->
    @$('.overlay').fadeOut(1000)
    @$('.message-container').fadeOut(1000)

  tooltip: ->
    @$('.overlay').fadeIn(1000)
    @$('.message-container').fadeIn(1000)

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  navigate: ->
    @app.navigate 'avatar', trigger: true

  render: ->
    @$el.html @template()