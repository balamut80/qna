class Answer < ActiveRecord::Base
  include Votable
  
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable

  after_create :calculate_reputation
  after_create :notify_answer
  after_create :notify_question_subscribers
  before_destroy :rollback_reputation

  accepts_nested_attributes_for :attachments

  validates :body, presence: true, length: { in: 5..2000 }

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def best!
    answers = question.answers
    answers.each do |a|
      Reputation.calculate(a.user, :best_answer, true)
    end
    answers.update_all(best: false)

    self.update(best: true)
    Reputation.calculate(self.user, :best_answer)
  end

  private

  def calculate_reputation
    Reputation.calculate(self.user, :create_answer)
  end

  def rollback_reputation
    Reputation.calculate(self.user, :create_answer, true)
  end

  def notify_answer
    AuthorMailer.answer(self).deliver_later
  end

  def notify_question_subscribers
    NotifySubscribersJob.perform_later(self)
  end
end
