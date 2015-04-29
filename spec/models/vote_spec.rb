require 'rails_helper'

RSpec.describe Vote, type: :model do

  let!(:user) { create(:user) }
  let!(:other_user) { create :user }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create :answer, question: question }

  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

end