class KeyExchangeChannel < ApplicationCable::Channel

  def subscribed
    stream_from "exchange_room_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", data)
  end
end
