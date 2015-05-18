module OmniauthMacros
	def mock_auth_facebook
		OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
		  'provider' => 'facebook',
			'uid' => '12345678',
			'info' => {
			  'email' => 'user@test.com'
			}
		})
	end

	def mock_auth_twitter
		OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
			'provider' => 'twitter',
			'uid' => '12345678',
			'info' => {}
		})
	end

end