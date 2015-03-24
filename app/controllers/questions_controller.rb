class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy!
      flash[:notice] = 'Question has been successfully deleted.'
      redirect_to questions_path
    else
      flash[:notice] = 'You can\'t delete this question. You are not the author of this question'
      render :show
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end