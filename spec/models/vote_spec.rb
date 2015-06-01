require 'rails_helper'

RSpec.describe Vote, type: :model do

  let!(:user) { create(:user) }
  let!(:other_user) { create :user }
  let!(:question) { create(:question, user: user) }

  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }


  describe 'User votes question' do

    it 'like' do
      expect{ question.vote(other_user, 1) }.to change(question.votes, :count).by(1)
      expect( question.voted_by?(other_user) ).to be true
      expect( question.votes.find_by(user: other_user).value).to eq 1
    end

    it 'unvote' do
      question.vote(other_user, 1)
      expect( question.voted_by?(other_user) ).to be true
      expect{ question.unvote(other_user) }.to change(question.votes, :count).by(-1)
      expect( question.voted_by?(other_user) ).to be false
    end

    it 'dislike' do
      expect{ question.vote(other_user, -1) }.to change(question.votes, :count).by(1)
      expect( question.voted_by?(other_user) ).to be true
      expect( question.votes.find_by(user: other_user).value).to eq -1
    end

    context 'reputation' do
      subject { build(:question, user: user) }

      it 'vote up changes user reputation +2' do
        expect { subject.vote(user,1) }.to change{user.reputation}.by 2
      end

      it 'vote down changes user reputation -2' do
        expect { subject.vote(user,-1) }.to change{user.reputation}.by -2
      end

      it 'unvote changes rollback user reputation' do
        subject.vote(user,1)
        expect { subject.unvote(user) }.to change{user.reputation}.by 0
      end
    end
  end

  describe 'User votes answer' do
    let!(:answer) { create :answer, question: question, user: user }

    it 'like' do
      expect{ answer.vote(other_user, 1) }.to change(answer.votes, :count).by(1)
      expect( answer.voted_by?(other_user) ).to be true
      expect( answer.votes.find_by(user: other_user).value).to eq 1
    end

    it 'unvote' do
      answer.vote(other_user, 1)
      expect( answer.voted_by?(other_user) ).to be true
      expect{ answer.unvote(other_user) }.to change(answer.votes, :count).by(-1)
      expect( answer.voted_by?(other_user) ).to be false
    end

    it 'dislike' do
      expect{ answer.vote(other_user, -1) }.to change(answer.votes, :count).by(1)
      expect( answer.voted_by?(other_user) ).to be true
      expect( answer.votes.find_by(user: other_user).value).to eq -1
    end

    context 'reputation' do
      subject { build(:answer, question: question, user: user) }

      it 'vote up changes user reputation +1' do
        expect { subject.vote(user,1) }.to change{user.reputation}.by 1
      end

      it 'vote down changes user reputation -2' do
        expect { subject.vote(user,-1) }.to change{user.reputation}.by -1
      end

      it 'unvote changes rollback user reputation' do
        subject.vote(user,1)
        expect { subject.unvote(user) }.to change{user.reputation}.by 0
      end
    end
  end
end
