$(document).on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).show();
});