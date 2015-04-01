require_relative 'acceptance_helper'

feature 'Create Answer' do

	given(:user) { create(:user) }
	given(:question) { create(:question) }

	scenario 'Authenticated user create the answer', js: true do
		sign_in(user)
		visit question_path(question)
		fill_in 'Text', with: 'Answer text'
		click_on 'Create Answer'

		expect(current_path).to eq question_path(question)
		within '.answers' do
			expect(page).to have_content 'Answer text'
		end
	end

	scenario 'Authenticated user try to create invalid answer', js: true do
		sign_in(user)
		visit question_path(question)

		click_on 'Create Answer'

		expect(page).to have_content 'Body is too short'
	end

	scenario 'Non-authenticated user try to create answer' do
		visit question_path(question)
		expect(page).to have_no_content 'Create answer'
	end

end