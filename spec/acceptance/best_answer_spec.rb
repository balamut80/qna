require_relative 'acceptance_helper'

feature 'Best answer' do

	given(:user) { create(:user) }
	given(:other_user) { create(:user) }
	given!(:question) { create(:question, user: user) }
	given!(:other_user_question) { create(:question, user: other_user) }
	given!(:answer) { create(:answer, question: question, user: user) }
	given!(:answers) { create_list(:answer, 2, question: question, user: user) }
	given!(:other_user_answers) { create_list(:answer, 2, question: other_user_question, user: other_user) }

	describe 'Question authenticated author' do

		before do
			sign_in(user)
			visit question_path(question)
		end

		scenario 'sees "Mark as best answer!" button', js: :true do
			within '.answers' do
				expect(page).to have_link 'Mark as best answer!'
			end
		end

		scenario 'try to make best answer', js: true do

			within "#answer-#{answer.id}" do
				expect(page).to_not have_content 'This is the best answer!'
				click_on 'Mark as best answer!'
			end
			expect(page).to have_selector('.answer', count: 3)

			within "#answer-#{answer.id}" do
				expect(page).to have_content answer.body
				expect(page).to have_content 'This is the best answer!'
      end
		end
	end

	describe 'Authenticated user who is not author of question' do
		scenario 'can\'t see "Mark as best answer!" button', js: :true do
			sign_in(user)
			visit question_path(other_user_question)

			expect(page).to_not have_content 'Mark as best answer!'
		end
	end

	describe 'Non-authenticated user' do
		scenario 'can\'t see "Mark as best answer!" button', js: :true do
			visit question_path(question)

			expect(page).to_not have_content 'Mark as best answer!'
		end
	end


end



