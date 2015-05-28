require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	let(:comment) { create(:comment) }
	let(:question) { create(:question) }
	let(:answer) { create(:answer, question: question) }
	let(:publish_channel) { "/questions/#{question.id}/comments" }


	describe 'GET #create' do

		context 'Authenticated user' do
			sign_in_user

			context 'for question' do

			  it_behaves_like "private publication"

			  it 'creates new comment' do
			    expect { do_request }.to change(question.comments, :count).by 1
				end

				def do_request
					post :create, comment: attributes_for(:comment),commentable: 'question', question_id: question, format: :js
				end
			end

			context 'for answer' do

				it_behaves_like "private publication"

				it 'creates new comment' do
				  expect { do_request }.to change(answer.comments, :count).by 1
				end

				def do_request
					post :create, comment: attributes_for(:comment), commentable: 'answer', answer_id: answer, format: :js
				end
			end
		end

		context 'Non authenticated user' do
			it 'cannot create comment' do
				expect { post :create, comment: attributes_for(:comment), question_id: question, format: :js }.to_not change(Comment, :count)
			end
		end

	end
end
