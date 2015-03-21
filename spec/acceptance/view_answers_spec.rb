require 'rails_helper'

feature 'View question answers' do

	given(:user) { create(:user) }
	given(:question) { create :question }
	given(:answer) { create :answer, question: question }


	scenario 'User selects a question and see its answers' do
		visit question_path(question)

		expect(page).to have_content answer.body
	end

end