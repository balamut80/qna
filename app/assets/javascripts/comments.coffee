$(document).on 'click', '.create-comment-link', (e) ->
  e.preventDefault();
  $(this).hide();
  resourceId = $(this).data('resourceId')
  resourceType = $(this).data('resourceType')
  $("form#comment-for-#{resourceType}-#{resourceId}").show()

$ ->
  questionId = $('.answers').data('questionId');
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment_data =
      comment: $.parseJSON(data['comment'])
      user: $.parseJSON(data['user'])
    resource_type = comment_data.comment.commentable_type.toLowerCase()
    $('#commentTmpl').tmpl(comment_data).appendTo('#' + resource_type + '-comments');
    $('#comment_body').val('')
    return