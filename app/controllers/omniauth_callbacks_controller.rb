class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		@user = User.find_for_oauth(request.env['omniauth.auth'])
		if @user.persisted?
			sign_in_and_redirect @user, event: :authentication
			set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
		end
	end

	def twitter
		@user = User.find_for_oauth(request.env['omniauth.auth'])
		if @user && @user.persisted?
			sign_in_and_redirect @user, event: :authentication
			set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
		else
			render partial: 'omniauth/confirm_email', locals: { auth: request.env['omniauth.auth'] }
		end
	end

	def confirm_email
		@user = User.find_for_oauth(OmniAuth::AuthHash.new(params[:auth]))
		if @user && @user.persisted?
			sign_in_and_redirect @user, event: :authentication
			set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
		else
			flash[:notice] = 'Can\'t authorize user without email'
			render partial: 'omniauth/confirm_email', locals: { auth: OmniAuth::AuthHash.new(params[:auth]) }
		end
	end

end
