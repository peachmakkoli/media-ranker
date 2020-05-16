class Work < ApplicationRecord
  has_many :votes
  validates :category, :title, presence: true
  validates :title, uniqueness: { scope: :category, case_sensitive: false }
  # TODO: add category validations, it can only be album, book, or movie

  # I chose to design a sort_works (by vote) method instead of creating a "votes" column in the works table, because there was a possibility that values in the votes column would not match up the actual number of vote records in the database
  def self.sort_works(category)
    raise ArgumentError.new("Error: Wrong argument passed in to Work.sort_works method") if !["album", "book", "movie"].include?(category)

    return Work.where(category: category).sort_by { |work| work.votes.count }.reverse!
  end 

  def self.top_ten(category)
    raise ArgumentError.new("Error: Wrong argument passed in to Work.top_ten method") if !["album", "book", "movie"].include?(category)

    return Work.where(category: category).limit(10).sort_by { |work| work.votes.count }.reverse!
  end

  def self.spotlight
    # TODO: move code block from homepages_controller into model
  end
end
