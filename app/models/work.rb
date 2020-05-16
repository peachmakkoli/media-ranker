class Work < ApplicationRecord
  has_many :votes
  validates :category, :title, presence: true
  validates :title, uniqueness: { scope: :category, case_sensitive: false }

  def self.sort_works(category)
    # raise ArgumentError if category is invalid
    # TODO: move code block from works_controller into model
  end

  def self.top_ten(category)
    # raise ArgumentError if category is invalid
    # TODO: move code block from homepages_controller into model
  end

  def self.spotlight
    # TODO: move code block from homepages_controller into model
  end
end
