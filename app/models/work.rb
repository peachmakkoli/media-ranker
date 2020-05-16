class Work < ApplicationRecord
  has_many :votes
  validates :category, :title, presence: true
  validates :title, uniqueness: { scope: :category, case_sensitive: false }

  def sort_works
    # move this from works_controller into model
  end

  def top_ten
    # move this from homepages_controller into model
  end
end
