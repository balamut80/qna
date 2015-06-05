require 'rails_helper'

describe Subscription do
  it { is_expected.to belong_to(:question) }
	it { is_expected.to belong_to(:user) }

	it { should validate_presence_of :question }
	it { should validate_presence_of :user }
end