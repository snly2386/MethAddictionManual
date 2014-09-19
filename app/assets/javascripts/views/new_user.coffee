class GettingOff.New_User extends Backbone.View
  
  template: JST["templates/new_user"]

  id: 'new-user'

  initialize: (options) -> 
    @app = options.app
    @id = options.id
    @page_animation()
    
    @render()
    @position()

    @template @id

  events:
    'click .accept.y' : 'accept_terms',
    'click .accept.n' : 'decline_terms'

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  accept_terms: ->
    @app.navigate 'new_theme', trigger: true

  decline_terms: ->
    alert 'You must accept terms to proceed'

  render: ->
    @$el.html @template()

  position: -> 
    $('#app').html @$el
    


