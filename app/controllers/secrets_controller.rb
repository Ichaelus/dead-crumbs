class SecretsController < ApplicationController
  def index
  end

  def generate
    ensure_room!
  end

  def create_key_parts
    n = allowed_params[:total_parts] &.to_i
    k = allowed_params[:required_parts] &.to_i
    if n > 0 && k > 0
      flash[:success] = 'OK! Here are your keys..' # todo
    else
      flash[:error] = 'Noop'
    end
    render action: :generate
  end

  def combine
    ensure_room!
  end

  def queue_part_combination
    key_parts = allowed_params[:key_parts] &.reject(&:blank?) || []
    if key_parts.any?
      # todo: websocket
      flash[:success] = 'Parts enqueued for combination'
    else
      flash[:error] = 'Please specify any key parts'
    end
    render action: :combine
  end

  private

  def ensure_room!
    unless allowed_params[:room].present?
      random_string = SecureRandom.hex
      redirect_to(room: random_string)
    end
  end

  def allowed_params
    params.permit(:room, :total_parts, :required_parts, :key_parts => [])
  end
end
