class SendMsgJob < ActiveJob::Base
  def perform(id)
    ActionCable.server.broadcast(
      'room_maze',
      body: id.to_s
    )
  end
end