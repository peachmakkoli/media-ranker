class Work < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :category, :title, presence: true
  validates :category, inclusion: { in: ["album", "book", "movie"] }
  validates :title, uniqueness: { scope: :category, case_sensitive: false }

  # I chose to design a sort_works (by vote) method instead of creating a "votes" column in the works table, because there was a possibility that values in the votes column would not match up the actual number of vote records in the database
  def self.sort_works(category)
    raise ArgumentError.new("Error: Wrong argument passed in to Work.sort_works method") if !["album", "book", "movie"].include?(category)

    return Work.where(category: category).sort_by{ |work| work.votes.count }.reverse!
  end 

  def self.top_ten(category)
    raise ArgumentError.new("Error: Wrong argument passed in to Work.top_ten method") if !["album", "book", "movie"].include?(category)

    return Work.where(category: category).limit(10).sort_by{ |work| work.votes.count }.reverse!
  end

  def self.spotlight
    highest = Work.all.map{ |work| work.votes.count }.max
    spotlight = Work.joins(:votes).group("works.id").having("count(work_id) = ?", highest).order("max(votes.created_at) DESC") # retrieves a list of works that have the highest number of votes, ordered by most recent vote (modified from Dorian and Arta's answer: https://stackoverflow.com/a/27772341)

    if Work.none? || Vote.none?
      return nil
    else
      return spotlight.first # if there is a tie, the work that was voted on most recently will be selected
    end
  end
end
