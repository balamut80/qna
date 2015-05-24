require 'rails_helper'

describe 'Questions API' do
	let(:access_token) { create(:access_token) }
	let!(:questions) { create_list(:question, 2) }
	let!(:question) { questions.last }

	# describe 'GET /index' do
	# 	it_behaves_like "check API Authentication"
	#
	# 	context 'authorized' do
	# 		let!(:answer) { create(:answer, question: question) }
	#
	# 		before { get '/api/v1/questions', format: :json, access_token: access_token.token }
	#
	# 		it 'returns 200 status code' do
	# 			expect(response).to be_success
	# 		end
	#
	# 		it 'returns list of questions' do
	# 			expect(response.body).to have_json_size(2).at_path("questions")
	# 		end
	#
	# 		%w(id title body created_at updated_at).each do |attr|
	# 			it "question object contains #{attr}" do
	# 				expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
	# 			end
	# 		end
	#
	# 		it 'question object contains short_title' do
	# 			expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
	# 		end
	#
	# 		context 'answers' do
	# 			it 'included in question object' do
	# 				expect(response.body).to have_json_size(1).at_path("questions/0/answers")
	# 			end
	#
	# 			%w(id body created_at updated_at).each do |attr|
	# 				it "contains #{attr}" do
	# 					expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
	# 				end
	# 			end
	# 		end
	# 	end
	#
	# 	def check_authentication(options = {})
	# 		get '/api/v1/questions', { format: :json }.merge(options)
	# 	end
	# end
	#
	# describe 'GET /show' do
	# 	let!(:comments) { create_list(:comment, 2, commentable: question) }
	# 	let!(:attachment) { create_list(:attachment,2, attachable: question) }
	#
	# 	it_behaves_like "check API Authentication"
	#
	# 	context 'authorized' do
	# 		context 'with valid question id' do
	# 			before { get "/api/v1/questions/#{question.id}", access_token: access_token.token, format: :json }
	#
	# 			it 'returns 200 status code' do
	# 				expect(response).to be_success
	# 			end
	#
	# 			%w(id title body created_at updated_at).each do |attr|
	# 				it "question object contains #{attr}" do
	# 					expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
	# 				end
	# 			end
	#
	# 			context 'comments' do
	# 				it 'included in question object' do
	# 					expect(response.body).to have_json_size(2).at_path("question/comments")
	# 				end
	#
	# 				%w{id body created_at updated_at}.each do |attr|
	# 					it "contains #{attr}" do
	# 						expect(response.body).to be_json_eql(comments.last.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
	# 					end
	# 				end
	# 			end
	#
	# 			context 'attachments' do
	# 				it 'included in question object' do
	# 					expect(response.body).to have_json_size(2).at_path("question/attachments")
	# 				end
	#
	# 				it 'contains attachment url' do
	# 					expect(response.body).to be_json_eql(attachment.last.file.url.to_json).at_path("question/attachments/0/url")
	# 				end
	# 			end
	# 		end
	# 	end
	#
	# 	def check_authentication(options = {})
	# 		get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
	# 	end
	# end

	describe 'POST /create' do
		let(:create_question) { post '/api/v1/questions', question: attributes_for(:question), access_token: access_token.token, format: :json }

		it_behaves_like "check API Authentication"

		context 'authorized' do
			it 'return status 201' do
				create_question
				expect(response.status).to eq 201
			end

			it 'creates new question' do
				expect{ create_question }.to change(Question, :count).by(1)
			end
		end

		def check_authentication(options = {})
			post '/api/v1/questions/', { question: attributes_for(:question), format: :json }.merge(options)
		end
	end
end