$(document).on 'click', '.edit-question-link', (e) ->
  e.preventDefault()
  $(this).hide()
  question_id = $(this).data('questionId')
  $('form#edit-question-' + question_id).show()

$ ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    console.log(1111)
    if (typeof data != 'undefined') and (data['question'])
      console.log(222)
      question = $.parseJSON(data['question'])
      $('#questionTmpl').tmpl(question).appendTo('.questions');
      return
