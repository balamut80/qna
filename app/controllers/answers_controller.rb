class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:destroy, :update, :best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if @answer.user_id == current_user.id
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def best
    @answer.best! if @question.user_id == current_user.id
  end

  private
  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body, :question_id, :user_id, attachments_attributes: [:file])
  end
end