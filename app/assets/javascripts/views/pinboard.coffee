class GettingOff.Pinboard extends GettingOff.View

  className: ->
    "pinboard"

  constructor: (options) ->
     @page = parseInt options.page
     super

  template: (attributes) -> JST["templates/pinboard"](attributes)

  initialize: (options) ->
    @app = options.app
    @photos = options.photos
    @cordova = options.cordova
    @color = "black"
    @counter = 5
   

  
    @page_animation()

    @photos.fetch
      success:(model, response, options) =>
        @render()
        @position()
        @populate_photos()
        @scroll_to_bottom()
    @$('.canvas').sketch(color: "red")


  events: ->
    'click .add-photo'            : 'select_photo'
    'click .submit'               : 'save_photo'
    'change .photo'               : 'save_url'
    'click .photo-container'      : 'bring_to_front'
    'click .next'                 : 'navigate'
    'mousedown .add-photo'        : 'button_effect'
    'mousedown .start-drawing'    : 'button_effect'
    'mouseup .add-photo'          : 'remove_button_effect'
    'mouseup .start-drawing'      : 'remove_button_effect'
    'click .table'                : 'table_of_contents'
    'click .calendar'             : 'calendar'
    'click .user'                 : 'user'
    'click .button'               : 'navigate'
    'click .previous'             : 'previous'
    'click .color'                : 'choose_color'
    'click .start-drawing'        : 'paint_tools'
    'click .work'                 : 'close_canvas'
    'click .tooltip'              : 'show_tooltip'
    'click .sketch-speech-bubble' : 'close_tooltip' 
    'click .photo-speech-bubble'  : 'close_tooltip'

  scroll_to_bottom: ->
    scrollElement = document.getElementById("mid-container")
    scrollElement.scrollTop = scrollElement.scrollHeight 

  close_tooltip: ->
    @$('.sketch-speech-bubble, .photo-speech-bubble').transition({width: '0px'},1000)
    @$('.tool-overlay').fadeOut(2000)

  show_tooltip: ->
    @$('.tool-overlay').fadeIn(2000)
    if @cordova is true
      @$('.sketch-speech-bubble, .photo-speech-bubble').transition({width: '300px'}, 1000)
    else  
      @$('.sketch-speech-bubble, .photo-speech-bubble').transition({width: '150px'}, 1000)

  close_canvas: ->
    @$('.canvas-container').hide('slide',{direction: 'left'}, 1000)
    @$('.paint-tools').fadeOut(1000)
    @$('.work-container').fadeOut(1000)

  show_canvas: ->
    @$('.canvas-container').show('slide',{direction: 'left'}, 1000)
    if @cordova is true
      @$('.canvas').attr('height', '630')

  paint_tools: ->
    @$(".paint-tools").fadeIn(1000)
    @$('.work-container').fadeIn(1000)
    @show_canvas()

  create_canvas: ->
    @$('.canvas').sketch(defaultColor: "#{@color}")

  choose_color: (e) ->
    $('.color').each( ->
      if $(@).hasClass('transitioned')
        $(@).transition({width: '30%'})
        $(@).removeClass('transitioned')
        $(@).removeClass('opaque')
      )
    target = $(e.currentTarget)
    target.addClass('transitioned')
    target.addClass('opaque')
    target.transition({width: '60%'}, 1000)

  previous: ->
    window.history.go(-1)

  page_animation: ->
    $('body').css('display', 'none')
    $('body').fadeIn(2000)

  pinboard: ->
    @app.navigate 'pinboard', trigger: true

  user: ->
    @app.navigate 'finish_setup', trigger: true

  table_of_contents: ->
    @app.navigate 'ch2/3', trigger: true

  calendar: ->
    @app.navigate 'ch2/2', trigger: true

  remove_button_effect: (e) ->
    $(e.currentTarget).removeClass('shrunk')

  button_effect: (e) ->
    $(e.currentTarget).addClass('shrunk')

  save_url: (e) ->
    # temp_url = URL.createObjectURL(e.target.files[0])
    reader = new FileReader()
    reader.onload = (e) => 
      random = Math.floor((Math.random() * 360) + 1)
      $('.photos-container').append("<div class='photo-container' style='transform:rotate(#{random}deg)'><img src='#{e.target.result}' class='pinboard-photos' style='left: #{@counter}%'/></div>").hide().fadeIn(2000)      
      $('.pinboard-photos').css('border', '5 px solid rgba(255, 255, 255, 0.38)')
      @save_photo(e.target.result)
      console.log '4'

    reader.readAsDataURL(e.target.files[0])
    @counter += 5
    console.log '5'

  save_photo: (url) ->

     photo = new GettingOff.Photo("file" : "#{url}")
     @photos.create(photo)
     @counter += 10


  # create_canvas:  ->
  #     @$('#drawing-board').sketch()

  populate_photos: ->
    counter = 5
    @photos.each (model) ->
      @$('.photos-container').append("<div class='photo-container' style='left:#{counter}%'><img src='#{model.get('file')}' class='pinboard-photos'/></div>")
        # @$('.photos-container').append("<canvas class='photo-container' style='background:url(#{model.get('file')}) no-repeat;'</canvas>")
      counter+=10
    @transform()

  transform: ->
    @$('.photo-container').each( ->
      random = Math.floor((Math.random() * 360) + 1)
      $(@).css('transform', "rotate(#{random}deg)")
      )

  bring_to_front: (e)->
    $('.photo-container').removeClass('animated')
    $('.photo-container').removeClass('rotateIn')
    $('.photo-container').css("z-index", "0")
    @$(e.currentTarget).addClass('animated')
    @$(e.currentTarget).addClass('rotateIn')
    @$(e.currentTarget).css("z-index", "5")

  select_photo: ->
    @$('.photo').click()

  navigate: ->
    @app.navigate 'avatar', trigger: true

  render: ->
    @$el.html @template()
