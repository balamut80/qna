$(document).on 'click', '.create-comment-link', (e) ->
  e.preventDefault();
  $(this).hide();
  resourceId = $(this).data('resourceId')
  resourceType = $(this).data('resourceType')
  $("form#comment-for-#{resourceType}-#{resourceId}").show()

$ ->
  questionId = $('.answers').data('questionId');
  console.log('/questions/' + questionId + '/comments')

  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    console.log(111)
    comment_data =
      comment: $.parseJSON(data['comment'])
      user: $.parseJSON(data['user'])
    resource_type = comment_data.comment.commentable_type.toLowerCase()
    console.log(comment_data)
    console.log(resource_type)
    $('#commentTmpl').tmpl(comment_data).appendTo('#' + resource_type + '-comments');
    $('#comment_body').val('')
    return