require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(200) }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(2000) }
  it { should have_many(:answers).dependent :destroy }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }


  # it 'validates presence of title' do
  #   expect(Question.new(body: 'body text')).to_not be_valid
  # end

  # it 'validates presence of body' do
  #   expect(Question.new(title: 'title text')).to_not be_valid
  # end
end
