require_relative 'acceptance_helper'

feature 'Delete files from answers' do

	let!(:user) { create(:user) }
	let!(:question) { create(:question, user: user) }
	let!(:answer) { create(:answer, question: question, user: user) }
	let!(:attachment) { create(:attachment, attachable: answer) }

	let!(:other_user) { create(:user) }
	let!(:other_user_question) { create(:question, user: other_user) }
	let!(:other_user_answer) { create(:answer, question: other_user_question, user: other_user) }
	let!(:other_user_answer_attachment) { create(:attachment, attachable: other_user_answer) }

	scenario 'Authenticated user try delete his answer attachment', js: true do
		sign_in(user)
		visit question_path(question)
		within ".answer-attachments" do
			within "#attachment-#{attachment.id}" do
				expect(page).to have_link 'spec_helper.rb'
				click_on 'remove'
			end
			expect(page).to_not have_link 'spec_helper.rb'
		end
	end

	scenario 'Non-authenticated user try delete his answer attachment' do
		visit question_path(question)
		within ".answer-attachments" do
			expect(page).to_not have_link 'remove'
		end
	end

	scenario 'Authenticated user try delete other user answer attachment' do
		sign_in(user)
		visit question_path(other_user_question)
		within ".answer-attachments" do
			expect(page).to_not have_link 'remove'
		end
	end
end