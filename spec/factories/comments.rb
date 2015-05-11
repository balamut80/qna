FactoryGirl.define do
	factory :comment do
		body "My Comment"
		association :commentable, factory: :question
		user
	end

	factory :invalid_comment, class: 'Comment' do
	  body nil
	end

end