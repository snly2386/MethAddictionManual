class GettingOff.Finish_Setup extends Backbone.View

  id: -> "finish-setup"

  template: JST['templates/finish_setup']
  
  initialize: (options) -> 
    @app = options.app
    @avatar = options.avatar
    @button = options.button
    @page_animation()


    @avatar.fetch
      success: (model, response, options) =>
        @avatar.set model.attributes[0]
        @render()
        @position()
        @render_avatar()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()



  events: 
    'click #icon-exit'  : 'navigate'
    'click .calendar'   : 'calendar'
    'click .table'      : 'go_to_table_of_contents'
    'click .user'       : 'user'
    'click .pin'        : 'pinboard'
    'click .button'     : 'navigate'
    'click .previous'   : 'previous'

  render_button: ->
    @$('.button').css('background-color',"#{@button.get('color')}")
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

  render_avatar: ->
    console.log @avatar.get('image')
    console.log @avatar
    @$('.avatar-container img').attr('src', "#{@avatar.get('image')}")
  
  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)
    
  navigate:  ->
    console.log 'working'
    @app.navigate 'ch1/1', trigger: true

  render: ->
    name = @model.get('name')
    @$el.html @template name: name
   

  position: -> 
    $('#app').html @$el






  create_overlay: (e) ->
    # target = $(e.currentTarget)
    # data = target.data('id')
    # @$('#' + data).css('visibility', 'visible').slideDown()
    # console.log(target)
    # @$('.finish-setup-icon-container').removeClass 'inactive_reverse active_reverse'
    # @$('.finish-overlay-container').removeClass 'active active_reverse'
    # target.siblings().addClass 'inactive'
    # target.addClass 'active'
    # data = target.data 'id'
    # @$('#' + data).addClass 'active'
    # $('body').addClass 'noscroll'

  close_overlay: (e) ->
    # target = $(e.currentTarget)
    # @$('.active, .finish-setup-icons-container').removeClass 'active'.addClass 'active_reverse'
    # # @$('.inactive, .finish-setup-icons-container').addClass'inactive_reverse'
    # target.parent().addClass('active_reverse')
    # @$('.inactive_reverse').bind AnimEnd ->
    #   $('body').removeClass 'noscroll'
    #   $('.finish-setup-icon-container').removeClass 'inactive'
    #   $('.inactive_reverse').unbind AnimEnd


