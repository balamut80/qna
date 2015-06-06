class AuthorMailer < ActionMailer::Base
	default from: "from@example.com"

	def answer(answer)
		@answer = answer
		mail to: answer.user.email
	end
end