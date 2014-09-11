class GettingOff.Chapter extends Backbone.Model

  defaults:
    completed: false
    page: 0

  percentage: -> (@get('page') / @get('total_pages')) * 100