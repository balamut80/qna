class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, presence: true, length: { in: 5..200 }
  validates :body, presence: true, length: { in: 5..2000 }

  default_scope -> { order('created_at DESC') }

end
