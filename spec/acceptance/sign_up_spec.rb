require_relative 'acceptance_helper'

feature 'Signing up' do

	given(:user) { create :user }

	scenario 'New user tries sign up' do
		visit new_user_registration_path
		fill_in 'Email', with: 'test@email.com'
		fill_in 'Password', with: '12345678'
		fill_in 'Password confirmation', with: '12345678'
		click_on 'Sign up'

		expect(page).to have_content 'Welcome! You have signed up successfully'
	end

	scenario 'Already registered user tries to sign up' do
		visit new_user_registration_path
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		fill_in 'Password confirmation', with: user.password
		click_on 'Sign up'

		expect(page).to have_content 'Email has already been taken'
	end

end