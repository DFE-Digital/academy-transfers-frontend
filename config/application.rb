require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovukRailsBoilerplate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes

    config.middleware.use Rack::Deflater

    # API Client credentials
    Rails.configuration.x.api.client_scope = ENV.fetch("API_CLIENT_SCOPE", Rails.application.credentials.api[:client_scope])
    Rails.configuration.x.api.client_id = ENV.fetch("API_CLIENT_ID", Rails.application.credentials.api[:client_id])
    Rails.configuration.x.api.client_secret = ENV.fetch("API_CLIENT_SECRET", Rails.application.credentials.api[:client_secret])

    # Authentication credentials
    Rails.configuration.x.default_user.username = ENV.fetch("DEFAULT_USER_USERNAME", Rails.application.credentials.default_user[:username])
    Rails.configuration.x.default_user.password = ENV.fetch("DEFAULT_USER_PASSWORD", Rails.application.credentials.default_user[:password])
  end
end
