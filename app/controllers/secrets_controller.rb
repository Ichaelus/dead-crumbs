class SecretsController < ApplicationController
  def index
  end

  def generate
    ensure_room!
  end

  def create_key_parts
    n = allowed_params[:total_parts] &.to_i
    k = allowed_params[:required_parts] &.to_i
    secret, parts = SharedSecret::Base.create(number_of_required_shares: k, number_of_total_shares: n)
    # todo: Only send the secret to the initiator
    flash.now[:success] = "Here is your new secret: #{secret}"

    parts = inject_required_part_number(parts, k)
    users = redis.smembers("room:#{params[:room]}:users")
    unless parts.count == users.count
      raise 'parts != users'
    end
    parts.zip(users).each do |part, user|
      ActionCable.server.broadcast("user_#{user}", { type: :message, message: "Your part is: #{part}" })
      ActionCable.server.broadcast("user_#{user}", { type: :file, message: part })
    end

    # Todo: Send each listener a part (WEBSOCKECT), including the number of required parts
  rescue ArgumentError => e
    raise e
    flash.now[:error] = e.message
  ensure
    render action: :generate
  end

  def combine
    ensure_room!
  end

  def queue_part_combination
    key_parts = allowed_params[:key_parts] &.reject(&:blank?) || []
    if key_parts.any?
      # todo add key_parts to room specifiy array
      # todo check if secret is ready and send it
      required_part_number, key_parts, = extract_required_part_number(key_parts)
      flash.now[:success] = "Parts enqueued for combination. Currently guessing your key is #{SharedSecret::Base.recover([key_parts])}"
      ActionCable.server.broadcast("exchange_room_#{allowed_params[:room]}", { type: :message, message: "#{key_parts.count} key parts have been added!" })
    else
      flash.now[:error] = 'Please specify any key parts'
    end
  rescue ArgumentError => e
    flash.now[:error] = e.message
  ensure
    render action: :combine
  end

  private

  def ensure_room!
    unless allowed_params[:room].present?
      random_string = SecureRandom.hex
      redirect_to(room: random_string)
    end
  end

  def inject_required_part_number(parts, required_part_number)
    parts.map do |part|
      "#{part}+++#{required_part_number}"
    end
  end

  def extract_required_part_number(parts)
    required_part_number = nil
    cleaned_parts = parts.map do |part|
      required_number_of_part = part.match(/\A[^+]+\+\+\+(?<required_part_number>\d+)\z/)&.[](:required_part_number)
      raise(ArgumentError, 'No required part number given') if required_number_of_part.blank?
      required_part_number ||= required_number_of_part
      if required_part_number != required_number_of_part
        raise(ArgumentError, "Different required part numbers specified")
      end
      part.gsub(/\+\+\+\d+\z/, '')
    end
    [required_part_number, cleaned_parts]
  end

  def allowed_params
    params.permit(:room, :total_parts, :required_parts, :key_parts => [])
  end
end
