FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password "password123"
    password_confirmation "password123"
    admin true
  end
end
