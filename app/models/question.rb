class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments

  validates :title, presence: true, length: { in: 5..200 }
  validates :body, presence: true, length: { in: 5..2000 }

  default_scope -> { order('created_at DESC') }

end
