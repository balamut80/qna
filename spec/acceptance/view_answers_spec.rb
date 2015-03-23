require 'rails_helper'

feature 'View question answers' do

	given(:user) { create(:user) }
	given(:question) { create :question }
	given!(:answers) { create_list(:answer, 10, question: question, user: user)}


	scenario 'User selects a question and see its answers' do
		visit question_path(question)

		answers.each do |a|
			expect(page).to have_content(a.body)
		end
	end

end