class Work < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :category, :title, presence: true
  validates :category, inclusion: { in: ["album", "book", "movie"] }
  validates :title, uniqueness: { scope: :category, case_sensitive: false }

  # all custom methods in the work model take advantage of counter_cache, inspired by cristian's solution: https://stackoverflow.com/a/24151460
  def self.sort_works(category)
    raise ArgumentError.new("Error: Wrong argument passed in to Work.sort_works method") if !["album", "book", "movie"].include?(category)

    return Work.where(category: category).order("votes_count DESC")
  end 

  def self.top_ten(category)
    raise ArgumentError.new("Error: Wrong argument passed in to Work.top_ten method") if !["album", "book", "movie"].include?(category)

    return Work.where(category: category).order("votes_count DESC").limit(10)
  end

  def self.spotlight
    if Work.none? || Vote.none?
      return nil
    else
      return Work.joins(:votes).group("works.id").order("votes_count DESC, max(votes.created_at) DESC").first # if there is a tie, the work that was voted on most recently will be selected
    end
  end
end
