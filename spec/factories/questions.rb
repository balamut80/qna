FactoryGirl.define do
  sequence :body do |n|
    "My Body Number #{n}"
  end

  factory :question do
    user
    title "My Question Title"
    body
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
