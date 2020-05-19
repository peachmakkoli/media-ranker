class User < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :username, presence: true, uniqueness: true

  def upvoted_works
    return Work.joins(:votes).where(votes: { user_id: self.id })
  end
end
