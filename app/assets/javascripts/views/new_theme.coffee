class GettingOff.New_Theme extends Backbone.View

  id: 'new-theme'

  template: JST["templates/new_theme"]

  initialize: (options) ->
    @render()
    @position()
    @app = options.app
    console.log @model

  events:
    'focus .name'       : 'focus_handler'
    'focusout .name '   : 'focusout_handler'
    'click .twin'       : 'change_theme'
    'click .button-next': 'create_user'

  focus_handler: ->
    # $('.name-border').css('background-color', 'rgb(19, 199, 92)')
    @$('.name-border').addClass 'name-border-toggle'

  focusout_handler: ->
    @$('.name-border').removeClass('name-border-toggle')

  change_theme:(e) ->
    target = $(e.currentTarget)
    theme = target.data('color')
    border = target.data('border')
    console.log(theme)
    $('body').css("background-image", "url(./assets/#{theme})")
    @$('.name-border, .twin-border').css('background-color', border)

  create_user: ->
    name = @$('.name').val()
    @model.save name: name

    console.log @model
    @navigate()

  navigate: ->
    @app.navigate 'finish_setup', trigger: true 
   
  render: ->
    @$el.html @template()

  position: ->
    $('#app').html(@$el)


   




