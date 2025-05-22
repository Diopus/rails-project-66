# frozen_string_literal: true

class AddWebhookForRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)
    client = ApplicationContainer[:octokit_client][repository.user.token]

    Repositories::AddWebhookService.new(repository:, client:).call
  end
end
