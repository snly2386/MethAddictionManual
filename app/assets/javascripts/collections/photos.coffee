class GettingOff.Photos extends Backbone.Collection

  model: GettingOff.Photo
  localStorage: new Backbone.LocalStorage('Pinboard_Photos')