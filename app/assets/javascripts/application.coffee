#= require_tree ./vendor
#= require_tree ./plugins
#= require namespace
#= require_tree ./extendables
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views

class GettingOff.Application extends Backbone.Router

  initialize: ->
    Backbone.history.start()


  routes:
    ''             : 'index'
    'new'          : 'new_user'
    'new_theme'    : 'new_theme'
    'pinboard'     : 'pinboard'
    'finish_setup' : 'finish_setup'
    'avatar'       : 'avatar'
    'ch1/:page'    : 'ch1'
    'ch2/:page'    : 'ch2'
    'ch3/:page'    : 'ch3'
    'ch4/:page'    : 'ch4'
    'ch5/:page'    : 'ch5'
    'ch6/:page'    : 'ch6'
    'ch7/:page'    : 'ch7'
    'ch8/:page'    : 'ch8'
    'ch9/:page'    : 'ch9'

  
  set_cordova: ->
    # @cordova = true

  create_calendar: ->
    @calendar_collection ||= new GettingOff.Calendar()

  create_avatar: ->
    @avatar_model ||= new GettingOff.Avatar_Model "image": "", id : 1
  
  create_photos: ->
    @photos ||= new GettingOff.Photos()

  avatar: ->
    @set_cordova()
    @create_avatar()
    view = new GettingOff.Avatar app: @, avatar: @avatar_model, cordova : @cordova

  pinboard: ->
    @render_button()
    @set_cordova()
    @create_photos()
    view = new GettingOff.Pinboard app: @, photos: @photos, cordova: @cordova, button: @button

  index: ->
    view = new GettingOff.Index app: @

  new_user: -> 
    @set_cordova()
    view = new GettingOff.New_User app: @, cordova: @cordova

  render_button: ->
    @button ||= new GettingOff.Button "color": "", "background" :"", id: 1

  new_theme: ->
    @set_cordova()
    @render_button()
    @user_create() 
    view = new GettingOff.New_Theme app: @, model: @user, button: @button, cordova: @cordova

  finish_setup: ->
    @render_button()
    @set_cordova()
    @create_avatar()
    @user_create()
    view = new GettingOff.Finish_Setup app: @, model: @user, avatar: @avatar_model, cordova: @cordova, button: @button

  new_user2: (id) ->
    view = new GettingOff.New_User app: @, id: id

  user_create: ->
    @user ||= new GettingOff.User() 
    # please fix me in the future

  answers_create: ->
    @relapse_questions ||= new GettingOff.Relapse_Questions "answer_1": "", "answer_2":"","answer_3":"","answer_4":"","answer_5":"","answer_6":""

  table_of_contents: ->
    @table_contents ||= new GettingOff.Table_Contents()

  create_chapters: ->
    @table_of_contents()
    chapter_3 = new GettingOff.Chapter chapter: 3, total_pages: 5, page: 3
    chapter_4 = new GettingOff.Chapter chapter: 4, total_pages: 2, page: 2
    chapter_5 = new GettingOff.Chapter chapter: 5, total_pages: 5, page: 5
    chapter_6 = new GettingOff.Chapter chapter: 6, total_pages: 9, page: 7
    chapter_7 = new GettingOff.Chapter chapter: 7, total_pages: 3, page: 1
    chapter_8 = new GettingOff.Chapter chapter: 8, total_pages: 6, page: 4
    chapter_9 = new GettingOff.Chapter chapter: 9, total_pages: 3, page: 2
    table_of_contents = [chapter_3, chapter_4, chapter_5, chapter_6, chapter_7, chapter_8, chapter_9]
    for chapter in table_of_contents
      @table_contents.create(chapter)


  ch5_questions_save: ->
    @ch5_questions ||= new GettingOff.Ch5_Questions "answer_1": "", "answer_2": "", "answer_3": "", "answer_4": "", "answer_5": ""

  ch5_create_names: ->
    @names ||= new GettingOff.Names()

  ch6_page2: ->
    @ch6_p2 ||= new GettingOff.Ch6_Page2 "answer_1": "", "answer_2": "", "answer_3": "" 

  ch6_page9: ->
    @ch6_p9 ||= new GettingOff.Ch6_Page9 "question_1" : "", "question_2": "","question_3": "", "question_4": "", "question_5": ""

  ch8_page6: ->
    @ch8_p6 ||= new GettingOff.Ch8_Page6 "question_1" : "", "question_2" : "", "question_3": ""

  ch9_page3: ->
    @ch9_p3 ||= new GettingOff.Ch9_Page3 "question_1" : "", "question_2": "", "question_3": ""

  ch1: (page) ->
    @set_cordova()
    @render_button()
    view = new GettingOff.Ch1 app: @, page: page, button: @button, cordova: @cordova

  ch2: (page) ->
    @set_cordova()
    @create_calendar()
    @render_button()
    @create_chapters()
    view = new GettingOff.Ch2 app: @, page: page, table_of_contents: @table_contents, button: @button, calendar_collection: @calendar_collection, cordova : @cordova

  ch3: (page) ->
    @render_button()
    @table_of_contents()
    view = new GettingOff.Ch3 app: @, page: page, table_of_contents: @table_contents, button: @button

  ch4: (page) ->
    @render_button()
    @table_of_contents()
    @answers_create()
    view = new GettingOff.Ch4 app: @, page: page, model: @relapse_questions, table_of_contents: @table_contents, button: @button

  ch5: (page) ->
    @render_button()
    @table_of_contents()
    @ch5_questions_save()
    @ch5_create_names()
    view = new GettingOff.Ch5 app: @, page: page, model: @ch5_questions, names: @names, table_of_contents: @table_contents, button: @button

  ch6: (page) ->
    @render_button()
    @table_of_contents()
    @ch6_page2()
    @ch6_page9()
    view = new GettingOff.Ch6 app: @, page: page, page2_model: @ch6_p2, page9_model: @ch6_p9, table_of_contents: @table_contents, button: @button

  ch7: (page) ->
    @render_button()
    @table_of_contents()
    view = new GettingOff.Ch7 app: @, page: page, table_of_contents: @table_contents, button: @button

  ch8: (page) ->
    @render_button()
    @table_of_contents()
    @ch8_page6()
    view = new GettingOff.Ch8 app: @, page: page, page6_model: @ch8_p6, table_of_contents: @table_contents, button: @button

  ch9: (page) ->
    @render_button()
    @table_of_contents()
    @ch9_page3()
    view = new GettingOff.Ch9 app: @, page: page, page3_model: @ch9_p3, table_of_contents: @table_contents, button: @button




  

