FactoryGirl.define do
	factory :comment do
		body "My Body"
		association :commentable, factory: :question
		user
	end

	factory :invalid_comment, class: 'Comment' do
	  body nil
	end

end