class GettingOff.Finish_Setup extends Backbone.View

  id: 'finish-setup'

  template: JST['templates/finish_setup']

  initialize: (options) -> 
    @app = options.app
    @render()
    @position()



  events: 
      'click #icon-exit'  :  'navigate'

  
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


