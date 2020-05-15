class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work
  validates :user_id, :work_id, presence: true
end
