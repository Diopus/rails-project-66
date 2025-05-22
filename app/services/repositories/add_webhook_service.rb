# frozen_string_literal: true

module Repositories
  class AddWebhookService
    include Rails.application.routes.url_helpers

    def initialize(repository:, client:)
      @repository = repository
      @client = client
      @hook_url = api_checks_url
    end

    def call
      if find_existing_hook
        Rails.logger.info("[Webhook] hook already exists for #{@repository.full_name}")
        return
      end

      config = { url: @hook_url, content_type: 'json' }
      options = { active: true, events: ['push'] }
      @client.create_hook(@repository.full_name, 'web', config, options)
    end

    private

    def find_existing_hook
      @client.hooks(@repository.full_name).find do |hook|
        hook.config.url == @hook_url
      end
    end
  end
end
