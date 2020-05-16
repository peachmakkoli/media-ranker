class HomepagesController < ApplicationController
  def index
    @albums = top_ten("album")
    @books = top_ten("book")
    @movies = top_ten("movie")

    @spotlight = Work.all.max_by { |work| work.votes.count }
  end

  def top_ten(category)
    return Work.where(category: category).limit(10).sort_by { |work| work.votes.count }.reverse!
  end
end
