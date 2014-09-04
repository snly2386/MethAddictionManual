   class GettingOff.User extends Backbone.Model

    defaults: 
      name: 'Anonymous'

    localStorage: new Backbone.LocalStorage('User')

    # initialize:(options) ->
    #   #@name = options.name