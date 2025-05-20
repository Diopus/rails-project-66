# frozen_string_literal: true

module Repositories
  class GithubService
    private

    def repo_language(repo)
      repo.language.presence || (repo.fork? && parent_language(repo))
    end

    def parent_language(repo)
      parent = @client.repository(repo.id).parent
      parent&.language
    end
  end
end
