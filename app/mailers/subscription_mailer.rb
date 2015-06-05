class SubscriptionMailer < ActionMailer::Base
	default from: "from@example.com"

	def question(subscriber, answer)
		@answer = answer
		mail to: subscriber.email
	end
end