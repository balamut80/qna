require 'rails_helper'

RSpec.describe Answer, type: :model do

  it_behaves_like 'votable'

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 5, question: question, user: user, best: false) }
  let!(:best_answer) { create(:answer, question: question, user: user, best: false) }
  let!(:other_best_answer) { create(:answer, question: question, user: user) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(2000) }
  it { should belong_to :question }

  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  it { should have_many(:votes).dependent(:destroy) }

  describe 'Make best answer' do
    before do
      best_answer.best!
      best_answer.reload
    end

    it 'sets to true' do
      expect(best_answer.best).to eq true
    end

    it 'only one question answer can be best' do
      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'checks changing is best flags on answers' do
      other_best_answer.best!
      best_answer.reload
      other_best_answer.reload

      expect(best_answer.best).to eq false
      expect(other_best_answer.best).to eq true
    end

    context 'reputation' do



      it 'make best changes user reputation +3' do
        subject { build(:answer, question: question, user: user, best: false) }
        expect { subject.best! }.to change{user.reputation}.by 3
        subject.destroy
      end

      it 'remove make best rollback user reputation' do
        subject { build(:answer, question: question, user: user, best: false) }
        expect { subject.best! }.to change{user.reputation}.by 0
        subject.destroy
      end
    end
  end

end
