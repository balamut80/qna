class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user
  has_many  :comments, as: :commentable

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :attachments

  validates :title, presence: true, length: { in: 5..200 }
  validates :body, presence: true, length: { in: 5..2000 }

  default_scope -> { order('created_at DESC') }
  scope :created_yesterday, -> { where(created_at: Time.zone.now.yesterday.all_day) }

  def subscription_by(user)
    subscriptions.find_by(user: user)
  end
end
