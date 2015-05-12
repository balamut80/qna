class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    respond_to do |format|
      if @question.save
        format.html do
          flash[:notice] = 'Your question successfully created.'
          PrivatePub.publish_to "/questions", question: @question.to_json
          redirect_to @question
        end
      else
        format.html { render 'new'}
      end
    end
  end

  def update
    @question.update(question_params) if @question.user_id == current_user.id
    @questions = Question.all
  end

  def destroy
      @question.destroy! if @question.user_id == current_user.id
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
