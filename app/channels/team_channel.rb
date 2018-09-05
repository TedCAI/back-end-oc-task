class TeamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room]}"
  end

  def unsubscribed
    ActionCable.server.remote_connections.where(current_user: current_user).disconnect if current_user
    current_user.update(team_id: nil) if current_user
  end
end