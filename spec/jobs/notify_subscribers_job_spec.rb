require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
	let(:user) { create(:user) }
	let(:question) { create(:question, user: user) }
	let(:answer) { create(:answer, question: question, user: user) }
	let(:other_user) { create(:user) }
	let(:subscriber) { create(:subscriber, user: other_user, question:answer.question) }

	before{ActionMailer::Base.deliveries = []}

	it 'send notice' do
		NotifySubscribersJob.perform_later(answer)
		expect(ActionMailer::Base.deliveries.count).to eq 1
	end
end