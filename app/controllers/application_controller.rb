class ApplicationController < ActionController::Base
  def find_work(id)
    @work = Work.find_by(id: id) 
    head :not_found if !@work
    return
  end
end
