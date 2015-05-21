class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  before_action :question_owner, only: [:destroy, :update]
  after_action :publish_question, only: [:create]

  authorize_resource

  respond_to :html
  respond_to :js, only: :destroy
  respond_to :json, only: :create

  include Voted

  def index
    respond_with @questions = Question.all
  end

  def show
    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def edit
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    @question.update(question_params)
    respond_with @questions = Question.all
  end

  def destroy
    respond_with @question.destroy!
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_owner
    unless @question.user_id == current_user.id
      render text: 'You do not have permission to modify this question', status: 403
    end
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end
end
