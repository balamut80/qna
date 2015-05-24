class Api::V1::AnswersController < Api::V1::BaseController
	before_action :load_question

	def index
		respond_with @question.answers.all
	end

	def show
		respond_with Answer.find(params[:id])
	end

	def create
		respond_with @answer = Answer.create(answer_params.merge(question: @question, user: current_resource_owner))
	end

	private
	def answer_params
		params.require(:answer).permit(:body, attachments_attributes: [:file])
	end

	def load_question
		@question = Question.find(params[:question_id])
	end
end