class UserChannel < ApplicationCable::Channel

  def subscribed
    @user_token = generate_user_token
    @room_id = params[:room]
    stream_from "user_#{@user_token}"
    redis.sadd("room:#{@room_id}:users", @user_token)
    user_count = redis.smembers("room:#{params[:room]}:users").count
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", { type: :message, message: "A user has joined the room. There are now #{user_count} users." })
  end

  def unsubscribed
    redis.srem("room:#{@room_id}:users", @user_token)
    user_count = redis.smembers("room:#{@room_id}:users").count
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", {type: :message, message: "A user has left the room. There are now #{user_count} users."})
  end

  private

  def generate_user_token
    SecureRandom.hex
  end

end
