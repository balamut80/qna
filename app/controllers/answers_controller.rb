class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:destroy, :update, :best]
  before_action :answer_owner, only: [:destroy, :update]
  before_action :question_owner, only: [:best]
  after_action :publish_answer, only: :create

  respond_to :html, :js

  include Voted

  def create
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_user)) if @question.valid?
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer
  end

  def best
    @answer.best!
    respond_with @answer
  end

  private
  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body, :question_id, :user_id, attachments_attributes: [:id, :file, :_destroy])
  end

  def answer_owner
    unless @answer.user_id == current_user.id
      render text: 'You do not have permission to modify this answer.', status: 403
    end
  end

  def question_owner
    unless @question.user_id == current_user.id
      render text: 'You do not have permission to modify this question', status: 403
    end
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers",
                          answer: @answer.to_json,
                          attachments: @answer.attachments.to_json,
                          total: @answer.total_votes.to_json
  end
end