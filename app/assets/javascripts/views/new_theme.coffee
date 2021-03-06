class GettingOff.New_Theme extends Backbone.View

  id: -> "new-theme"

  template: JST["templates/new_theme"]
  
  initialize: (options) ->
    @app = options.app
    @button = options.button
    @page_animation()
    @fastclick()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()

    @render()
    @position()


  events:
    'focus .name'       : 'focus_handler'
    'focusout .name '   : 'focusout_handler'
    'click .twin'       : 'change_theme'
    'click .button'     : 'create_user'
    'mousedown .button' : 'mousedown_effect'
    'mouseup .button'   : 'mouseup_effect'

  fastclick: ->
    FastClick.attach(document.body)

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  mousedown_effect: ->
    @$('.button').addClass('shrunk')

  mouseup_effect: ->
    @$('.button').removeClass('shrunk')

  render_button: ->
    @$('.button').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")   

  focus_handler: ->
    @$('.name-border').addClass 'name-border-toggle'

  focusout_handler: ->
    @$('.name-border').removeClass('name-border-toggle')

  change_theme:(e) ->
    target = $(e.currentTarget)
    theme = target.data('color')
    border = target.data('border')
    button = target.data('button')
    $('body').css("background-image", "url('#{theme}'')")
    @$('.name-border, .twin-border').css('background-color', border)
    @button.set('color', button)
    @button.set('background', "url(./assets/#{theme})" )
    @button.save()
    @render_button()
    

  create_user: ->
    name = @$('.name').val()
    @model.save name: name

    console.log @model
    @navigate()

  navigate: ->
    @app.navigate 'menu', trigger: true 
   
  render: ->
    @$el.html @template()

  position: ->
    $('#app').html(@$el)


   




