class User < ApplicationRecord
  has_many :votes
  validates :username, presence: true, uniqueness: true

  def upvoted_works(user)
    # throw exception if the user is invalid
    # loop through user.votes
    # lookup Works table, return all Works whose id matches vote.work_id
  end
end
