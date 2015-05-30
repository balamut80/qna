shared_examples 'votable' do

	it { should have_many(:votes).dependent(:destroy) }

	let!(:user) { create(:user) }
	let!(:like_user) { create(:user) }
	let!(:dislike_user) { create(:user) }
	subject(:votable) { create(described_class.to_s.underscore.to_sym, user: user) }

	describe 'User votes' do

		it 'like' do
			expect{ votable.vote(like_user, 1) }.to change(votable.votes, :count).by(1)
		end

		it 'dislike' do
			expect{ votable.vote(dislike_user, -1) }.to change(votable.votes, :count).by(1)
		end

	end

	describe 'User unvotes' do

		it 'votable model' do
			votable.vote(like_user, 1)
			expect{ votable.unvote(like_user) }.to change(votable.votes, :count).by(-1)
		end

	end

	describe 'User checks' do

		it 'voted by?' do
			votable.vote(like_user, 1)
			expect( votable.voted_by?(like_user) ).to be true
		end

		it 'total votes' do
		  votable.vote(like_user, 1)
		  expect(votable.total_votes).to eq 1
	  end

	end

end