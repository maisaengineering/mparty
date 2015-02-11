Invitation::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  #config.active_record.migration_error = :page_load

  # SET DEFAULT TIMEZONE FOR ACTIVE RECORD QUERYING
  config.active_record.default_timezone = :local
  
  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'

  config.action_mailer.delivery_method = :letter_opener #:smtp
  # change to false to prevent email from being sent during development
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
  ENV['SENDER'] = 'labs@maisasolutions.com'


  # ENV['CDN_URL'] = 'https://d1l5f2v82xoaic.cloudfront.net'
  config.action_mailer.smtp_settings = {
      :address => "smtp.yandex.ru",
      :port => 25,
      :enable_starttls_auto => true,
      :user_name => 'labs@maisasolutions.com',
      :password => 'MPRIDE786',
      :authentication => :plain
  }


end
