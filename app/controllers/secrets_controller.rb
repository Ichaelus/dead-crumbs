class SecretsController < ApplicationController
  def index
  end

  def generate
    unless allowed_params[:room].present?
      random_string = SecureRandom.hex
      redirect_to(room: random_string)
    end
  end

  def combine
  end

  private

  def allowed_params
    params.permit(:room)
  end
end
