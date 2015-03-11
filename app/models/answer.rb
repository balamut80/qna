class Answer < ActiveRecord::Base

  belongs_to :question, class_name: 'Question', foreign_key: 'question_id'

  validates :body, presence: true, length: { in: 5..2000 }

end
