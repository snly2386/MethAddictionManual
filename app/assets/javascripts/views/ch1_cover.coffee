class GettingOff.Ch1_Cover extends GettingOff.View

  id: -> "ch1_cover"
  
  template: -> JST["templates/ch1_cover"] 

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
    

  events: 
    'click .button'                        : 'navigate'
    'click .previous'                      : 'previous'
    'click .user, .table, .calendar, .pin' : 'alert_message'

  alert_message: ->
    alert 'This navigation tool has been disabled for this page.'

  previous: ->
    window.history.go(-1)

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  render_button: ->
    @$('.button, .finish-chapter').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")

  navigate: ->
    @app.navigate 'ch1/1', trigger: true

  render: ->
    @$el.html @template()


 


