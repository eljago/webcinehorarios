Webcinehorarios::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  
  # Change mail delivery to either :smtp. :sendmail, :file, :test
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "ajenti.cinehorarios.cl",
    port: 25,
    domain: "cinehorarios.cl",
    authentication: "plain",
    enable_starttls_auto: false,
    user_name: Rails.application.secrets.mail_account,
    password: Rails.application.secrets.mail_password
  }
  
  #req for devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true


  # BULLET
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end
end
