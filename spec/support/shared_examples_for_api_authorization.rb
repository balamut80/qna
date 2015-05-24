shared_examples_for "check API Authentication" do
	context 'unauthorized' do
		it 'returns 401 status if there is no access_token' do
			check_authentication
			expect(response.status).to eq 401
		end

		it 'returns 401 status if access_token is invalid' do
			check_authentication(access_token: '123')
			expect(response.status).to eq 401
		end
	end
end