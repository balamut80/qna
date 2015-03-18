require 'rails_helper'

feature 'Delete Answer' do

	given(:user) { create(:user) }
	given(:other_user) { create(:user) }
	given(:question) { create(:question) }
	given(:answer) { create :answer, question: question, user: user }

	scenario 'Authenticated user try delete his answer' do
		sign_in(user)
		visit question_path(question)
		click_on 'Delete answer'

		expect(page).to have_content 'Answer has been successfully deleted'
	end

	scenario 'Authenticated user try delete others answer' do
		sign_in(other_user)
		visit question_path(question)

		expect(page).to_not have_content 'Delete answer'
	end
end