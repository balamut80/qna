class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:destroy, :update, :best]
  before_action :answer_owner, only: [:destroy, :update]

  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}/answers",
                                answer: @answer.to_json,
                                attachments: @answer.attachments.to_json,
                                total: @answer.total_votes.to_json
          render nothing: true
        end
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.json { render json: {answer: @answer} }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
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

  def answer_owner
    unless @answer.user_id == current_user.id
      render text: 'You do not have permission to modify this answer.', status: 403
    end
  end
end