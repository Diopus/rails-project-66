# frozen_string_literal: true

module Repositories
  class FetchInfoService < GithubService
    def initialize(client:, repository:) # rubocop:disable Lint/MissingSuper
      @client = client
      @repository = repository
    end

    def call
      repository_data = @client.repo @repository.github_id
      {
        name: repository_data.name,
        github_id: repository_data.id,
        full_name: repository_data.full_name,
        language: repo_language(repository_data),
        clone_url: repository_data.clone_url,
        ssh_url: repository_data.ssh_url
      }
    end
  end
end
