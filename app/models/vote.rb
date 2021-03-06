class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work, counter_cache: true
  validates :user_id, :work_id, presence: true
  validates :user, uniqueness: { scope: :work_id, message: "has already voted for this work" }
end
