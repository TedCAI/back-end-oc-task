class SendMsgJob < ActiveJob::Base
  def perform(id)
    ActionCable.server.broadcast(
      'room_maze',
      title: 'the title',
      body: id.to_s
    )
  end
end