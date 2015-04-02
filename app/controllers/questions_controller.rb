class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all.order('created_at DESC')
  end

  def show
    @answer = Answer.new
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

  def update
    @question.update(question_params) if @question.user_id == current_user.id
    @questions = Question.all.order('created_at DESC')
  end

  def destroy
      @question.destroy! if @question.user_id == current_user.id
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
