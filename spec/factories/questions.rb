FactoryGirl.define do
  factory :question do
    user
    title "MyString"
    body "MyQuestion"
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
