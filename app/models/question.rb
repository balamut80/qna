class Question < ActiveRecord::Base

  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { in: 5..200 }
  validates :body, presence: true, length: { in: 5..2000 }

end
