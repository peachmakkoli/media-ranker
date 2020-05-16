class HomepagesController < ApplicationController
  def index
    @albums = Work.top_ten("album")
    @books = Work.top_ten("book")
    @movies = Work.top_ten("movie")

    @spotlight = Work.spotlight
  end
end
