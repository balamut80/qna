class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :load_commentable, only: :create

	def create
		@comment = @commentable.comments.create(comments_params.merge(user_id: current_user.id))
		respond_to do |format|
			format.js  do
				PrivatePub.publish_to(
						"/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments",
						comment: @comment.to_json,
						user: @comment.user.to_json
				)
				render nothing: true
			end if @comment.errors.empty?
		end
	end

	private

	def load_commentable
		parameter = (params[:commentable].singularize + '_id').to_sym
		@commentable = params[:commentable].classify.constantize.find(params[parameter])
		puts @commentable
	end

	def comments_params
		params.require(:comment).permit(:body)
	end

end