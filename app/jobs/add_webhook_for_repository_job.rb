# frozen_string_literal: true

class AddWebhookForRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find_by(id: repository_id)
    return unless repository

    client = ApplicationContainer[:octokit_client][repository.user.token]

    Repositories::AddWebhookService.new(repository:, client:).call
  end
end
