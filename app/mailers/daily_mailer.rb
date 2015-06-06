class DailyMailer < ActionMailer::Base
	default from: "from@example.com"

	def digest(user)
		@questions = Question.created_yesterday
		mail to: user.email
	end
end