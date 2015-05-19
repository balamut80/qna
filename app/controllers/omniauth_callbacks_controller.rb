class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		sign_in_omniauth('Facebook')
	end

	def twitter
		sign_in_omniauth('Twitter')
	end

	def confirm_email
		sign_in_omniauth('Twitter')
	end

	private

	def auth
		request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
	end

  def sign_in_omniauth(provider)
		if session['devise.omniauth_data']
			auth['uid'] = session['devise.omniauth_data']['uid']
			auth['provider'] = session['devise.omniauth_data']['provider']
		end
		@user = User.find_for_oauth(auth)
		if @user && @user.persisted?
			sign_in_and_redirect(@user, event: :authentication)
			set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
		else
			session['devise.omniauth_data'] = auth.except('extra')
			render partial: 'omniauth/confirm_email'
		end
	end
end
