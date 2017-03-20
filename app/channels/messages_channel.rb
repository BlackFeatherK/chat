class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room_id]}"

    Rails.logger.debug('subscribed messages')
  end

  def speak(data)
    room = Room.find(params[:room_id])

    message = room.messages.new(content: data['content'])
    message.user = current_user

    if message.save
      html = ApplicationController.renderer.render(partial: 'messages/message', locals: {message: message})
      ActionCable.server.broadcast("room_#{room.id}", html)
    else

    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
