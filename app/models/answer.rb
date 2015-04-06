class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { in: 5..2000 }

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def best!
    question.answers.update_all(best: false)
    self.update(best: true)
  end
end
