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
    @color = "black"
    @counter = 5

    @page_animation()

    @photos.fetch
      success:(model, response, options) =>
        @render()
        @position()
        @populate_photos()
    
    @$('.canvas').sketch(defaultColor: "#{@color}")


  events: ->
    'click .add-photo'       : 'select_photo'
    'click .submit'          : 'save_photo'
    'change .photo'          : 'save_url'
    'click .photo-container' : 'bring_to_front'
    'click .next'            : 'navigate'
    'mousedown .shrink'      : 'button_effect'
    'mouseup .shrink'        : 'remove_button_effect'
    'click .table'           : 'table_of_contents'
    'click .calendar'        : 'calendar'
    'click .user'            : 'user'
    'click .button'          : 'navigate'
    'click .previous'        : 'previous'


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

  remove_button_effect: ->
    @$('.shrink').removeClass('shrunk')

  button_effect: ->
    @$('.shrink').addClass('shrunk')

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

