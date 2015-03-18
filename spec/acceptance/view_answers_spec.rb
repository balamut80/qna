require 'rails_helper'

feature 'View question answers' do

	given(:question) { create :question }
	given(:answer) { create :answer, question: question }


	scenario 'User selects a question and see its answers' do
		visit questions_path
		click_on question.title

		expect(page).to have_content answers.last.body
	end

end