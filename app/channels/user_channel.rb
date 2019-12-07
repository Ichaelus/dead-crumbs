class UserChannel < ApplicationCable::Channel

  def subscribed
    @user_token = generate_user_token
    @room_id = params[:room]
    stream_from "user_#{@user_token}"
    redis.sadd("room:#{@room_id}:users", @user_token)
    user_count = redis.smembers("room:#{params[:room]}:users").count
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", { type: :message, message: "A user has joined the room. There are now #{user_count} users." })
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", { type: :'user-count-changed', message: user_count })
  end

  def unsubscribed
    room_users_key = "room:#{@room_id}:users"
    redis.srem(room_users_key, @user_token)
    user_count = redis.smembers(room_users_key).count
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", {type: :message, message: "A user has left the room. There are now #{user_count} users."})
    ActionCable.server.broadcast("exchange_room_#{params[:room]}", { type: :'user-count-changed', message: user_count })
    if user_count == 0
      redis.del(room_users_key)
    end
  end

  private

  def generate_user_token
    SecureRandom.hex
  end

end
