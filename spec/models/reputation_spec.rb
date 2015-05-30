require 'rails_helper'

RSpec.describe Reputation, type: :model do

	describe 'Calculate reputation' do
		let(:user) { create :user }

		context 'Questions actions' do
			context 'Vote' do
				context 'up' do
					it 'returns +2 to user reputation' do
						expect { Reputation.calculate(user, :vote_question) }.to change{user.reputation}.by 2
					end
				end
				context 'down' do
					it 'returns -2 to user reputation' do
						expect { Reputation.calculate(user, :unvote_question) }.to change{user.reputation}.by -2
					end
				end

				context 'unvote' do
					it 'rollback user reputation if unvote vote up' do
						expect { Reputation.calculate(user, :vote_question, true) }.to change{user.reputation}.by -2
					end

					it 'rollback user reputation if unvote vote down' do
						expect { Reputation.calculate(user, :unvote_question, true) }.to change{user.reputation}.by 2
					end
				end
			end
		end

		context 'Answers actions' do
			context 'Create new' do
				it 'returns +1 to user reputation' do
					expect { Reputation.calculate(user, :create_answer) }.to change{user.reputation}.by 1
				end

				it 'rollback user reputation if delete' do
					expect { Reputation.calculate(user, :create_answer, true) }.to change{user.reputation}.by -1
				end
			end

			context 'Make best' do
				it 'returns +3 to user reputation' do
					expect { Reputation.calculate(user, :best_answer) }.to change{user.reputation}.by 3
				end

				it 'rollback to user reputation if change best answer' do
					expect { Reputation.calculate(user, :best_answer, true) }.to change{user.reputation}.by -3
				end
			end
			context 'Vote' do
				context 'up' do
					it 'returns +1 to user reputation' do
						expect { Reputation.calculate(user, :vote_answer) }.to change{user.reputation}.by 1
					end
				end
				context 'down' do
					it 'returns -1 to user reputation' do
						expect { Reputation.calculate(user, :unvote_answer) }.to change{user.reputation}.by -1
					end
				end

				context 'unvote' do
					it 'rollback user reputation if unvote vote up' do
						expect { Reputation.calculate(user, :vote_answer, true) }.to change{user.reputation}.by -1
					end

					it 'rollback user reputation if unvote vote down' do
						expect { Reputation.calculate(user, :unvote_answer, true) }.to change{user.reputation}.by 1
					end
				end
			end
		end
	end
end