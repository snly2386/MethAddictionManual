class GettingOff.Avatar extends GettingOff.View

  className: ->
    "avatar"

  constructor: (options) ->
     @page = parseInt options.page    
     super

  template: (attributes) -> JST["templates/avatar"](attributes)

  initialize: (options) ->
    @app = options.app
    @avatar = options.avatar
    @button = options.button

    @page_animation()

    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
    
    @render()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @position()

  events: 
    'click .avatar'   : 'preview_avatar'
    'click .button'   : 'avatar_model'
    'click .table'    : 'go_to_table_of_contents'
    'click .user'     : 'user'
    'click .pin'      : 'pinboard'
    'click .calendar' : 'calendar'
    'click .previous' : 'previous'

  render_button: ->
    @$('.button, .finish-chapter').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}") 

  scroll_to_top: ->
    scrollElement = document.getElementById("mid-container")
    target = $('#mid-container')
    $('#mid-container').animate({scrollTop: '0'}, 2000, 'easeOutBounce')

  previous: ->
    window.history.go(-1)

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  user: ->
    @app.navigate 'finish_setup', trigger: true

  go_to_table_of_contents: ->
    @app.navigate 'ch2/4', trigger: true 

  pinboard: ->
    @app.navigate 'pinboard', trigger: true

  calendar: ->
    @app.navigate 'ch2/3', trigger: true

  animate_page: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  avatar_model: ->
    image = $('.selected-avatar img').attr('src')
    @avatar.set("image", "#{image}")
    @avatar.save()
    console.log @avatar.get('image')
    @navigate()

  preview_avatar: (e) ->
    target = $(e.currentTarget)
    $('.image').css('opacity', '0.5')
    src = target.find('img').attr('src')
    target.find('img').css('opacity', '1')
    @$('.selected-avatar img').hide()
    @$('.selected-avatar img').attr('src', "#{src}")
    @$('.selected-avatar img').fadeIn(1000)
    @scroll_to_top()

  navigate: ->
    @app.navigate 'finish_setup', trigger: true

  render: ->
    @$el.html @template()
