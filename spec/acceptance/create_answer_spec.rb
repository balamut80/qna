require 'rails_helper'

feature 'Create Answer' do

	given(:user) { create(:user) }
	given(:question) { create(:question) }

	scenario 'Authenticated user create the answer' do
		sign_in(user)
		visit question_path(question)
		click_on 'Answer'
		fill_in 'Text', with: 'Answer text'
		click_on 'Create Answer'

		expect(page).to have_content 'Your answer successfully created.'
	end

	scenario 'Non-authenticated user try to create answer' do
		visit question_path(question)
		click_on 'Answer'

		expect(page).to have_content 'You need to sign in or sign up before continuing.'
	end

end