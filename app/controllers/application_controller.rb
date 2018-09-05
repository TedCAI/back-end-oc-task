class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :disconnect

  def disconnect
    ActionCable.server.remote_connections.where(current_user: current_user).disconnect if current_user
    current_user.update!(team_id: nil) if current_user
  end
end
