require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create :user }
    let(:question) { create :question  }
    let(:subscriber) { create :user }
    let(:answer) { create :answer, question: question }
    let(:mail) { SubscriptionMailer.question(subscriber, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Answer")
			expect(mail.to).to eq([subscriber.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello, subscriber")
		end
  end

end