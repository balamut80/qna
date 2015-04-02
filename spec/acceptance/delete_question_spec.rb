require_relative 'acceptance_helper'

feature 'Delete questions' do

	given(:user) { create(:user) }
	given(:other_user) { create(:user) }
	given!(:question) { create :question, user: user }

	scenario 'Authenticated user try delete his question', js: true do
		sign_in(user)
		visit '/questions'
		click_on 'Delete question'

		expect(page).to_not have_content question.title
	end

	scenario 'Authenticated user try delete others question' do
		sign_in(other_user)
		visit '/questions'

		expect(page).to_not have_content 'Delete question'
	end

	scenario 'Non-authenticated user try delete his question' do
		visit '/questions'

		expect(page).to have_no_content 'Delete question'
	end

end