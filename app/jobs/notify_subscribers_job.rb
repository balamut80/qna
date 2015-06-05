class NotifySubscribersJob < ActiveJob::Base
	queue_as :default

	def perform(answer)
		answer.question.subscribers do |subscriber|
		  SubscriptionMailer.question(subscriber, answer).deliver_later
		end
	end
end