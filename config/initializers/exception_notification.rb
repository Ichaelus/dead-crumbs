require 'exception_notification/rails'

ExceptionNotification.configure do |config|

  config.add_notifier :email, {
    email_prefix: '[dead_crumbs] ',
    exception_recipients: %w[neonmate@users.noreply.github.com],
    sender_address: Rails.configuration.system_email,
    sections: %w[request data backtrace],
    background_sections: %w[data backtrace],
  }

  # Regularly occurs when users have multiple tabs open
  config.ignored_exceptions += %w[ActionController::InvalidAuthenticityToken]

end