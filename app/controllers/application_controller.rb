class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def success_flash(record)
    flash[:success] = "#{record.model_name.human} successfully saved"
  end

  def error_flash(record)
    flash.now[:error] = "#{record.model_name.human} could not be saved"
  end

  def destroy_flash(record)
    flash[:success] = "#{record.model_name.human} deleted"
  end

end
