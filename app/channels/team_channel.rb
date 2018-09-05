class TeamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room]}"
  end

  def unsubscribed
    current_user.update(team_id: nil) if current_user
  end
end