window.smart_alert = (options) ->
  if options['phonegap']
    navigator.notification.alert options.message, null, options.title, options.okay_button_text
  else  
    alert options.message  
