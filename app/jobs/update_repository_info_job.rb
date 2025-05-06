class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)
    client = client = Octokit::Client.new
    
    return unless repository_attributes = Github::Repositories::FetchInfoService.new(repository:, client:).call

    repository.assign_attributes(repository_attributes)
    repository.save!
  end
end
