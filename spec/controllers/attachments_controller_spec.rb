require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
	sign_in_user

	let!(:question) { create(:question, user: @user) }
	let!(:question_attachment) { create(:attachment, attachable: question) }

	let!(:other_user) { create :user }
	let!(:other_user_question) { create(:question, user: other_user) }
	let!(:other_user_question_attachment) { create(:attachment, attachable: other_user_question) }

	let!(:answer) { create(:answer, question: question, user: @user) }
	let!(:answer_attachment) { create(:attachment, attachable: answer) }

	let!(:other_user_answer) { create(:answer, question: other_user_question, user: other_user) }
	let!(:other_user_answer_attachment) { create(:attachment, attachable: other_user_answer) }

	describe 'DELETE #destroy' do

		context 'answer attachment' do

			it 'user deletes his answer attachment' do
				expect { delete :destroy, id: answer_attachment, format: :js }.to change(Attachment, :count).by(-1)
			end

			it 'user can\'n delete other user answer attachment' do
				expect{ delete :destroy, id: other_user_answer_attachment, format: :js }.not_to change(Attachment, :count)
			end

			it 'renders template destroy' do
				delete :destroy, id: answer_attachment, format: :js
				expect(response).to render_template :destroy
			end
		end

		context 'questions attachment' do

		  it 'user deletes his question attachment' do
			  expect { delete :destroy, id: question_attachment, format: :js }.to change(Attachment, :count).by(-1)
		  end

		  it 'user can\'n delete other user question attachment' do
			  expect{ delete :destroy, id: other_user_question_attachment, format: :js }.not_to change(Attachment, :count)
		  end

		  it 'renders template destroy' do
		  	delete :destroy, id: question_attachment, format: :js
			  expect(response).to render_template :destroy
		  end
		end
	end
end