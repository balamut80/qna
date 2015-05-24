class Api::V1::AnswersController < Api::V1::BaseController
	authorize_resource

	before_action :load_question, except: :show

	def index
		respond_with @question.answers.all
	end

	def show
		respond_with Answer.find(params[:id])
	end

	def create
		@answer = @question.answers.create answer_params.merge(user: current_resource_owner)
		respond_with @question, @answer
	end

	private
	def answer_params
		params.require(:answer).permit(:body)
	end

	def load_question
		@question = Question.find(params[:question_id])
	end
end