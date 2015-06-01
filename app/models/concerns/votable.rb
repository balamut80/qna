module Votable
	extend ActiveSupport::Concern

	included do
		has_many :votes, as: :votable, dependent: :destroy
	end

	def vote(user, value)
		vote = votes.find_or_initialize_by(user: user)
		vote.value = value
		calculate_reputation(vote) if vote.save!
	end

	def unvote(user)
		user_votes = votes.where(user: user)
		user_votes.each do |v|
			calculate_reputation(v, true)
		end
		user_votes.delete_all
	end

	def voted_by?(user)
		votes.where(user: user).exists?
	end

	def total_votes
		votes.sum :value
	end

	private

	def calculate_reputation(vote, rollback = false)
		action = (vote.value == 1) ? 'vote' : 'unvote'
		action += "_#{vote.votable_type}"
		Reputation.calculate(vote.user, action, rollback)
	end
end