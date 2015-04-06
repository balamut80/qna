require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 5, question: question) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(2000) }
  it { should belong_to :question }

  describe 'Make best' do
    before do
      answer.best!
      answer.reload
    end

    it 'sets to true' do
      expect(answer.best).to eq true
    end

    it 'only one question answer is best' do
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
end
