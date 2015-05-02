$(document).on 'click', '.edit-answer-link', (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).attr('data-answer-id')
  $('form#edit-answer-' + answer_id).show()
  return

$(document).on 'ajax:success', 'form.edit_answer', (e, data, status, xhr) ->
  answer = xhr.responseJSON.answer
  $(".answer[id='answer-" + answer.id + "'] .answer-body").text(answer.body);

$(document).on 'ajax:success', '.vote-link', (e, data, status, xhr) ->
  total = xhr.responseJSON.total
  resource = xhr.responseJSON.resource
  if xhr.responseJSON.class == "Answer"
    $("#answer-" + resource.id + " .total-votes").text(total);
    vote = $("#answer-" + resource.id + " .vote")
    vote.empty();
    html_source = '<p><a class="unvote-link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.question_id + '/answers/' + resource.id + '/unvote">Unvote</a></p>'
  if xhr.responseJSON.class == "Question"
    $("#question-" + resource.id + " .total-votes").text(total);
    vote = $("#question-" + resource.id + " .vote")
    vote.empty();
    html_source = '<p><a class="unvote-link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.id + '/unvote">Unvote</a></p>'
  vote.html(html_source);

$(document).on 'ajax:success', '.unvote-link', (e, data, status, xhr) ->
  total = xhr.responseJSON.total
  resource = xhr.responseJSON.resource
  if xhr.responseJSON.class == "Answer"
    $("#answer-" + resource.id + " .total-votes").text(total);
    vote = $("#answer-" + resource.id + " .vote")
    vote.empty();
    html_source_like = '<p><a class="vote-link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.question_id + '/answers/' + resource.id + '/vote?value=1">Like</a><p>'
    html_source_dislike = '<p><a class="vote-link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.question_id + '/answers/' + resource.id + '/vote?value=-1">Dislike</a><p>'
  if xhr.responseJSON.class == "Question"
    $("#question-" + resource.id + " .total-votes").text(total);
    vote = $("#question-" + resource.id + " .vote")
    vote.empty();
    html_source_like = '<p><a class="vote-link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.id + '/vote?value=1">Like</a><p>'
    html_source_dislike = '<p><a class="vote-link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.id + '/vote?value=-1">Dislike</a><p>'
  vote.html(html_source_like + html_source_dislike)

$ ->
  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    questionId = $('.answers').data('questionId');
    channel = '/questions/' + questionId + '/answers'
    PrivatePub.subscribe channel, (data, channel) ->
      answer_data =
        answer: $.parseJSON(data['answer'])
        attachments: $.parseJSON(data['attachments'])
      $('#answerTmpl').tmpl(answer_data).appendTo('.answers');
      $('form#new_answer #answer_body').val('');

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append value



