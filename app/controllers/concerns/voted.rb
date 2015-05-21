module Voted
	extend ActiveSupport::Concern

	included do
		before_action :load_voted, only: [:vote, :unvote]
		#before_action :user_can_vote, only: [:vote, :unvote]
	end

	def vote
		authorize! :vote, @resource
		@resource.vote(current_user, params[:value])# unless @resource.voted_by?(current_user)
		respond_to do |format|
			format.json { render json: {resource: @resource, total: @resource.total_votes, class: @resource.class.name} }
		end
	end

	def unvote
		authorize! :unvote, @resource
		@resource.unvote(current_user)
		respond_to do |format|
			format.json { render json: {resource: @resource, total: @resource.total_votes, class: @resource.class.name} }
		end
	end

	private

	def load_voted
		@resource = controller_name.classify.constantize.find(params[:id])
	end

	def user_can_vote
		if @resource.user_id == current_user.id
			render text: 'You do not have permission to view this page.', status: :forbidden
		end
	end
end