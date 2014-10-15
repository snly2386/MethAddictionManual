class GettingOff.Ch1_Cover extends GettingOff.View

  id: -> "ch1_cover"
  
  constructor: (options) ->
    @page = parseInt options.page
    super

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
    'click .button' : 'navigate'

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  navigate: ->
    @app.navigate 'ch1/1', trigger: true

  render: ->
    @$el.html @template()


 


