class SubscriptionMailer < ActionMailer::Base
	default from: "from@example.com"

	def answer(subscriber, answer)
		@answer = answer
		mail to: subscriber.email
	end
end