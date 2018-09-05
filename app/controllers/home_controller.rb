class HomeController < ApplicationController
  def index
    @active_chapter = Chapter.active
  end
  
  def leaderboard
    @infos = UserAction.result_details.sort {|a, b| a[:score] <=> b[:score]}
  end
end
