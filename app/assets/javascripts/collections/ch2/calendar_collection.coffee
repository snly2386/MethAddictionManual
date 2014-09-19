class GettingOff.Calendar extends Backbone.Collection

  model: GettingOff.Date
  localStorage: new Backbone.LocalStorage('Date')