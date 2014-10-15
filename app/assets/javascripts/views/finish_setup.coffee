class GettingOff.Finish_Setup extends Backbone.View

  id: -> "finish-setup"

  template: JST['templates/finish_setup']
  
  initialize: (options) -> 
    @model = options.model
    @app = options.app
    @avatar = options.avatar
    @button = options.button
    @page_animation()
    @fastclick()


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

  fastclick: ->
    FastClick.attach(document.body)

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
    @$('.avatar-container img').attr('src', "#{@avatar.get('image')}")
  
  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)
    
  navigate:  ->
    console.log 'working'
    @app.navigate 'ch1_cover', trigger: true

  render: ->
    name = @model.get('name')
    @$el.html @template name: name
   

  position: -> 
    $('#app').html @$el







