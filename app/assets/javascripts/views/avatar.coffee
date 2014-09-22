class GettingOff.Avatar extends GettingOff.View

  className: ->
    "#{@stylesheet}"

  constructor: (options) ->
     @page = parseInt options.page
     if options.cordova is true
        @stylesheet = 'cordova-avatar'
      else
        @stylesheet = 'avatar'     
     super

  template: (attributes) -> JST["templates/avatar"](attributes)

  initialize: (options) ->
    @app = options.app
    @avatar = options.avatar
    console.log @avatar

    @page_animation()

    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
    
    @render()
    @position()

  events: 
    'click .avatar'   : 'preview_avatar'
    'click .button'   : 'avatar_model'
    'click .table'    : 'go_to_table_of_contents'
    'click .user'     : 'user'
    'click .pin'      : 'pinboard'
    'click .previous' : 'previous'

  previous: ->
    window.history.go(-1)

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  user: ->
    @app.navigate 'finish_setup', trigger: true

  go_to_table_of_contents: ->
    @app.navigate 'ch2/3', trigger: true 

  pinboard: ->
    @app.navigate 'pinboard', trigger: true

  calendar: ->
    @app.navigate 'ch2/2', trigger: true

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
    @$('.selected-avatar img').attr('src', "#{src}")

  navigate: ->
    @app.navigate 'finish_setup', trigger: true

  render: ->
    @$el.html @template()
