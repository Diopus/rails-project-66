# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require_relative 'helpers/authentication_helpers'

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    setup do
      Rails.application.routes.default_url_options[:locale] = I18n.default_locale
    end
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationHelpers
end
