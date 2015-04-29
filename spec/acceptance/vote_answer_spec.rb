require_relative 'acceptance_helper'

feature 'Vote answer' do
	given!(:user) { create :user }
	given!(:other_user) { create(:user) }
	given!(:question) { create :question, user: user }
	given!(:answer) { create(:answer, question: question, user: user) }

	context 'Authenticated non-author' do
		before do
			sign_in(other_user)
			visit question_path(question)
		end

		scenario 'likes', js: true do
			within "#answer-#{answer.id}" do
				within '.vote' do
					click_on 'Like'
				end
				within '.total-votes' do
					expect(page).to have_content '1'
				end
			end
		end

		scenario 'dislikes', js: true do
			within "#answer-#{answer.id}" do
				within '.vote' do
					click_on 'Dislike'
				end
				within '.total-votes' do
					expect(page).to have_content '-1'
				end
			end
		end

		scenario 'unvotes', js: true do
			within "#answer-#{answer.id}" do
				click_on 'Like'
				expect(page).to have_content '1'
				click_on 'Unvote'
				expect(page).to have_content '0'
			end
		end
	end

	context 'Authenticated author user' do
		scenario 'can\'t vote', js: true do
			sign_in(user)
			visit question_path(question)

			within "#answer-#{answer.id}" do
				expect(page).to_not have_link 'Like'
				expect(page).to_not have_link 'Dislike'
				expect(page).to_not have_link 'Unvote'
			end
		end
	end

	context 'Non-authenticated user' do
		scenario 'can\'t vote', js: true do
			visit question_path(question)

			within "#answer-#{answer.id}" do
				expect(page).to_not have_link 'Like'
				expect(page).to_not have_link 'Dislike'
				expect(page).to_not have_link 'Unvote'
			end
		end
	end
end