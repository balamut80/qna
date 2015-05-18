require_relative 'acceptance_helper'

feature 'Omniauth' do

	let!(:user) { create(:user) }

	before do
		OmniAuth.config.test_mode = true
		visit root_path
	end

	describe 'sign in with twitter' do
		before do
			click_on 'Sign in'
			mock_auth_twitter
			click_on 'Sign in with Twitter'
		end

		scenario 'user successfully sign in from twitter with valid email' do
			expect(page).to have_content 'Please fill in the email to complete authorization'
			fill_in 'auth_info_email', with: 'test@email.com'
			click_on 'Complete'
			expect(page).to have_content 'Successfully authenticated from Twitter account'
		end

		scenario 'user try sign in from twitter with empty email' do
			expect(page).to have_content 'Please fill in the email to complete authorization'
			fill_in 'auth_info_email', with: ''
			click_on 'Complete'
			expect(page).to have_content 'Please fill in the email to complete authorization'
		end
	end

	describe 'sign in with facebook' do
		scenario 'user successfully sign in from facebook' do
			click_on 'Sign in'
			mock_auth_facebook
			click_on 'Sign in with Facebook'
			expect(page).to have_content 'Successfully authenticated from Facebook account'
		end
	end

end