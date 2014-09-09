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
    'finish_setup' : 'finish_setup'
    'ch1/:page'    : 'ch1'
    'ch2/:page'    : 'ch2'
    'ch3/:page'    : 'ch3'
    'ch4/:page'    : 'ch4'
    'ch5/:page'    : 'ch5'
    'ch6/:page'    : 'ch6'
    'ch7/:page'    : 'ch7'
    'ch8/:page'    : 'ch8'
    'ch9/:page'    : 'ch9'
  

  index: ->
    view = new GettingOff.Index app: @

  new_user: -> 
    view = new GettingOff.New_User app: @

  new_theme: ->
    @user_create() 
    view = new GettingOff.New_Theme app: @, model: @user

  finish_setup: ->
    @user_create()
    view = new GettingOff.Finish_Setup app: @, model: @user

  new_user2: (id) ->
    view = new GettingOff.New_User app: @, id: id

  user_create: ->
    @user ||= new GettingOff.User() 
    # please fix me in the future

  answers_create: ->
    @relapse_questions ||= new GettingOff.Relapse_Questions "answer_1": "", "answer_2":"","answer_3":"","answer_4":"","answer_5":"","answer_6":""

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
    view = new GettingOff.Ch1 app: @, page: page

  ch2: (page) ->
    view = new GettingOff.Ch2 app: @, page: page

  ch3: (page) ->
    view = new GettingOff.Ch3 app: @, page: page

  ch4: (page) ->
    @answers_create()
    view = new GettingOff.Ch4 app: @, page: page, model: @relapse_questions

  ch5: (page) ->
    @ch5_questions_save()
    @ch5_create_names()
    view = new GettingOff.Ch5 app: @, page: page, model: @ch5_questions, names: @names

  ch6: (page) ->
    @ch6_page2()
    @ch6_page9()
    view = new GettingOff.Ch6 app: @, page: page, page2_model: @ch6_p2, page9_model: @ch6_p9

  ch7: (page) ->
    view = new GettingOff.Ch7 app: @, page: page

  ch8: (page) ->
    @ch8_page6()
    view = new GettingOff.Ch8 app: @, page: page, page6_model: @ch8_p6

  ch9: (page) ->
    @ch9_page3()
    view = new GettingOff.Ch9 app: @, page: page, page3_model: @ch9_p3




  

