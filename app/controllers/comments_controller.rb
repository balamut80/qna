class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :load_commentable, only: :create
	after_action :publish_comment, only: :create

	authorize_resource

	respond_to :js

	def create
		respond_with @comment = @commentable.comments.create(comments_params.merge(user_id: current_user.id))
	end

	private

	def load_commentable
		parameter = (params[:commentable].singularize + '_id').to_sym
		@commentable = params[:commentable].classify.constantize.find(params[parameter])
	end

	def comments_params
		params.require(:comment).permit(:body)
	end

  def publish_comment
		PrivatePub.publish_to(
				"/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments",
				comment: @comment.to_json,
				user: @comment.user.to_json
		)
	end

end