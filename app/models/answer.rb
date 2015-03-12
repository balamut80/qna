class Answer < ActiveRecord::Base

  belongs_to :question

  validates :body, presence: true, length: { in: 5..2000 }

end
