require_relative 'acceptance_helper'

RSpec.feature 'Comments', type: :feature do

	given!(:user) { create :user }
	given!(:question) { create :question, user: user }
	given!(:answer) { create :answer, user: user, question: question }

	context 'Authenticated user' do
		before do
			sign_in(user)
			visit question_path(question)
		end

		scenario 'creates new comment for a question', js: true do
			within '#create-question-comment' do
				click_on 'Comment that'
				fill_in 'comment_body', with: 'My question comment'
				click_on 'Create comment'
			end

			expect(page).to have_content 'My question comment'
			expect(page).to have_content user.email
		end

		scenario 'creates new comment for an answer', js: true do
			within '#create-answer-comment' do
				click_on 'Comment that'
				fill_in 'comment_body', with: 'My answer comment'
				click_on 'Create comment'
			end

			expect(page).to have_content 'My answer comment'
			expect(page).to have_content user.email
		end
	end

	context 'Unauthenticated user' do
		before { visit question_path(question) }

		scenario 'can not comment a answer' do
			within "#answer-#{answer.id}" do
				expect(page).not_to have_link 'Add comment'
			end
		end
	end

end