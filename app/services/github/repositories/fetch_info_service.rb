# frozen_string_literal: true

module Github
  module Repositories
    class FetchInfoService
      def initialize(repository:, client:)
        @repository = repository
        @client = client
      end

      def call
        repository_data = @client.repo @repository.github_id
        {
          name: repository_data.name,
          github_id: repository_data.id,
          full_name: repository_data.full_name,
          language: repository_data.language,
          clone_url: repository_data.clone_url,
          ssh_url: repository_data.ssh_url
        }
      end
    end
  end
end
