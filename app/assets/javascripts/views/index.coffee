class GettingOff.Index extends Backbone.View
  id: 'index'
  template: JST['templates/index']

  events:
    'click .newuser'     : 'new_user'
    'mousedown .newuser' : 'mousedown_effect'
    'mouseup  .newuser'  : 'mouseup_effect'


  initialize: (options) ->
    @app = options.app

    @page_animation()
    @render()
    @position()

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  mousedown_effect: ->
    @$('.newuser').addClass('shrunk') 

  mouseup_effect: ->
    @$('.newuser').removeClass('shrunk')

  new_user: ->
    @app.navigate 'new', trigger: true

  render: ->
    console.log @template()
    @$el.html @template()

  position: ->
    $('#app').html @$el

