require "rails_helper"

RSpec.describe AuthorMailer, type: :mailer do
	describe 'create new_answer' do
		let(:user) { create :user }
		let(:question) { create :question  }
		let(:answer) { create :answer, question: question, user: user }
		let(:mail) { AuthorMailer.answer(answer) }

		it 'renders the headers' do
			expect(mail.subject).to eq('Answer')
			expect(mail.to).to eq([user.email])
			expect(mail.from).to eq(['from@example.com'])
		end

		it 'renders the body' do
			expect(mail.body.encoded).to match('There is new answer to your question')
		end
	end

end