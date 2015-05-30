class Reputation

	VALUES = {
			:create_answer   => 1,
			:vote_question   => 2,
			:unvote_question => -2,
			:vote_answer     => 1,
			:unvote_answer   => -1,
			:best_answer     => 3,
	}

	def self.calculate(user, action, rollback = false)
		value = VALUES[action.downcase.to_sym]
		value = -value if rollback
		user.increment!(:reputation, value) unless user.nil?
	end

end