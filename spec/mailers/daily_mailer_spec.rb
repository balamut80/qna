require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
	describe 'digest' do
		let!(:user) { create(:user) }
		let!(:mail) { DailyMailer.digest(user) }

		it 'renders the headers' do
			expect(mail.subject).to eq('Digest')
			expect(mail.to).to eq([user.email])
			expect(mail.from).to eq(['from@example.com'])
		end

		describe '.send_daily_digest' do
			it 'sends daily digest to all users' do
				User.all do |user|
					expect(DailyMailer).to receive(:dayly_digest).with(user).and_call_original
				end

				User.send_daily_digest
			end
		end
	end
end