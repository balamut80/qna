require 'rails_helper'

feature 'Delete questions' do

	given(:user) { create(:user) }
	given(:other_user) { create(:user) }
	given(:question) { create :question, user: user }

	scenario 'Authenticated user try delete his question' do
		sign_in(user)
		visit question_path(question)
		click_on 'Delete question'

		expect(page).to have_content 'Question has been successfully deleted'
		expect(page).to_not have_content question.title
		expect(page).to_not have_content question.body
	end

	scenario 'Authenticated user try delete others question' do
		sign_in(other_user)
		visit question_path(question)

		expect(page).to_not have_content 'Delete question'
	end

	scenario 'Non-authenticated user try delete his question' do
		visit question_path(question)

		expect(page).to have_no_content 'Delete question'
	end

end