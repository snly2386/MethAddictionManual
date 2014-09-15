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
    @counter = 30

    
    @photos.fetch
      success:(model, response, options) =>
        @render()
        @position()
        @populate_photos()


  events: ->
    'click .add-photo'       : 'select_photo'
    'click .submit'          : 'save_photo'
    'change .photo'          : 'save_url'
    'click .pinboard-photos' : 'bring_to_front'



  save_url: (e) ->
    # temp_url = URL.createObjectURL(e.target.files[0])
    reader = new FileReader()
    console.log '1'
    reader.onload = (e) => 
      $('.content').append("<img src='#{e.target.result}' class='pinboard-photos' style='left: #{@counter}%'/>").hide().fadeIn(2000)      
      # @make_draggable()
      @save_photo(e.target.result)
      console.log '4'

    reader.readAsDataURL(e.target.files[0])
    @counter += 5
    console.log '5'

  save_photo: (url) ->
     # image = document.getElementById("#{@counter}")
     # image_data = @get_base64_image(image)

     # photo = new GettingOff.Photo("file" : "data:image/png;base64," + "#{image_data}", 'id' : "#{@counter}" )
     photo = new GettingOff.Photo("file" : "#{url}")
     @photos.create(photo)
     @counter += 1
     console.log '3'

  make_draggable: ->
    # @$('.pinboard-photos').draggable()
    console.log 'fuck'


  get_base64_image: (image) ->
    canvas = document.createElement('canvas')
    canvas.width = image.width
    canvas.height = image.height

    ctx = canvas.getContext('2d')
    ctx.drawImage(image, 0, 0, image.width, image.height)

    dataURL = canvas.toDataURL("image/png")
    console.log dataURL
    dataURL.replace(/^data:image\/(png|jpg);base64,/, "")
  

  populate_photos: ->
    counter = 20
    @photos.each (model) ->
      @$('.content').append("<img src='#{model.get('file')}' class='pinboard-photos' style='left: #{counter}%;'/>")
      counter+=5
    @transform()

  transform: ->
    @$('.pinboard-photos').each( ->
      random = Math.floor((Math.random() * 45) + 1)
      $(@).css('transform', "rotate(#{random}deg)")
      console.log 'fucking work'
      )

  bring_to_front: (e)->
    $('.pinboard-photos').removeClass('animated')
    $('.pinboard-photos').removeClass('rotateIn')
    $('.pinboard-photos').css("z-index", "0")
    @$(e.currentTarget).addClass('animated')
    @$(e.currentTarget).addClass('rotateIn')
    @$(e.currentTarget).css("z-index", "5")

  select_photo: ->
    @$('.photo').click()

  render: ->
    @$el.html @template()