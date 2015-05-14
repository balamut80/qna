class AttachmentsController < ApplicationController
	before_action :authenticate_user!
	before_action :load_attachment
	before_action :attachment_owner

	respond_to :js, :json

	def destroy
		@attachment.destroy if @attachment.attachable.user_id == current_user.id
	end

	private

	def load_attachment
		@attachment = Attachment.find(params[:id])
	end

	def attachment_owner
		unless @attachment.attachable.user_id == current_user.id
			render text: 'You do not have permission to modify this attachment', status: 403
		end
	end

end