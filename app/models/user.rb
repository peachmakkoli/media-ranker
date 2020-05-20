class User < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :username, presence: true, uniqueness: true

  def upvoted_works
    return Work.joins(:votes).where(votes: { user_id: id })
  end

  def voted_on(work)
    raise ArgumentError.new("Error: Wrong work_id passed in to user#voted_on method") if !work
    
    return votes.find_by(work_id: work.id).created_at
  end
end
