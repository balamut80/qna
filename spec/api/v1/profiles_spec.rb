require 'rails_helper'

describe 'Profile API' do
	describe 'GET /me' do
		context 'unauthorized' do
			it 'returns 401 status if there is no access_token' do
				get '/api/v1/profiles/me', format: :json
				expect(response.status).to eq 401
			end

			it 'returns 401 status if access_token is invalid' do
				get '/api/v1/profiles/me', format: :json, access_token: '1234'
				expect(response.status).to eq 401
			end
		end

		context 'authorized' do
			let(:me) { create(:user) }
			let(:access_token) { create(:access_token, resource_owner_id: me.id) }

			before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

			it 'returns 200 status' do
				expect(response).to be_success
			end

			%w(id email created_at updated_at admin).each do |attr|
				it "contains #{attr}" do
					expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
				end
			end

			%w(password encrypted_password).each do |attr|
				it "does not contain #{attr}" do
					expect(response.body).to_not have_json_path(attr)
				end
			end
		end
	end

	describe 'GET /index' do
		context 'authorized' do
			let!(:me) { create :user }
			let(:access_token) { create :access_token, resource_owner_id: me.id }
			let!(:users) { create_list :user, 2 }

			before { get '/api/v1/profiles/', format: :json, access_token: access_token.token }

			it 'returns status ok' do
				expect(response).to be_success
			end

			it 'returns list of users except resource owner' do
				expect(response.body).to be_json_eql(users.to_json)
				expect(response.body).to_not include_json(me.to_json)
			end
		end
	end
end