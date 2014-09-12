class GettingOff.Ch8 extends GettingOff.View

  className: ->
    "ch8page-#{@page}"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: (attributes) -> JST["templates/ch8/#{@page}"](attributes)

  initialize: (options) ->
    @app = options.app
    @page6_model = options.page6_model
    @table_of_contents = options.table_of_contents
    @button = options.button

    @page6_model.fetch
      success:(model, response, options) =>
        @page6_model.set model.attributes[0]


    @table_of_contents.fetch
      success:(model, response, options) =>
        @update_table_of_contents()

    @render()

    @button.fetch
      success:(model, response, options) =>
        @button.set model.attributes[0]
        @render_button()
        
    @position()

  events: 
    'click .button'         : 'navigate'
    'click .list p'         : 'add_check'
    'click .finish-chapter' : 'page6_save'

  render_button: ->
    @$('.button, .finish-chapter, .page2-model, .page9-model').css('background-color',"#{@button.get('color')}")
    $('body').css("background-image", "#{@button.get('background')}")
  
  update_table_of_contents: ->
    model = @table_of_contents.findWhere({chapter: 8})
    model.set('page', @page)
    model.save()


  add_check: (e) ->
    target = @$(e.currentTarget)
    if target.hasClass('click-list')
      target.removeClass('click-list')
      console.log target
      console.log target.find('img')
      target.find('img').remove()
    else
      target.addClass('click-list')
      target.prepend("<img src='assets/progress_check.png'/>")

  page6_save: ->
    counter = 1
    @$('.textarea').each( =>
        @page6_model.set("question_#{counter}", $(".#{counter}").val())
        counter++
      )
    @page6_model.save()
    @ch9()

  ch9:->
    @app.navigate "ch9/1", trigger: true

  navigate: ->
    next_chapter = @page + 1
    @app.navigate "ch8/#{next_chapter}", trigger: true

  render: ->
    @$el.html @template @page6_model.toJSON()