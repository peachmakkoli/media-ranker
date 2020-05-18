class User < ApplicationRecord
  has_many :votes
  validates :username, presence: true, uniqueness: true

  def upvoted_works
    return self.votes.map{ |vote| Work.find_by(id: vote.work_id) }
  end
end
