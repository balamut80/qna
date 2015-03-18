require 'rails_helper'

feature 'Signing up' do

	given(:user) { create :user }

	scenario 'New user try to sign up' do
		visit new_user_registration_path
		fill_in 'Email',    with: 'test@email.com'
		fill_in 'Password', with: '12345678'
		fill_in 'Password confirmation', with: '12345678'
		click_on 'Sign up'

		expect(page).to have_content 'Welcome! You have signed up successfully'
	end

end