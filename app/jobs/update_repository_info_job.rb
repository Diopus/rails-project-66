# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id, add_webhook: false)
    repository = Repository.find(repository_id)
    client = ApplicationContainer[:octokit_client][repository.user.token]

    return unless (repository_attributes = Repositories::FetchInfoService.new(repository:, client:).call)

    repository.assign_attributes(repository_attributes)
    repository.save!

    AddWebhookForRepositoryJob.perform_later(repository_id) if add_webhook
  end
end
