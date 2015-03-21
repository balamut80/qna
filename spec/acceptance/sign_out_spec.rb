require 'rails_helper'

feature 'Signing out' do

	given(:user) { create(:user) }

	scenario 'Existing user try to sign out' do
		sign_in(user)
		click_on 'Sign out'

		expect(page).to have_content 'Signed out successfully.'
	end

end