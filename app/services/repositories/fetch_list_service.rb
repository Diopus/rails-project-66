# frozen_string_literal: true

module Repositories
  class FetchListService < GithubService
    def initialize(client:) # rubocop:disable Lint/MissingSuper
      @allowed_langs = Repository.language.values.to_set(&:downcase)
      @client = client
    end

    def call
      repos = @client.repos.filter_map do |repo|
        lang = repo_language(repo)
        repo if lang && @allowed_langs.include?(lang.downcase)
      end

      repos.pluck(:name, :id)
    end
  end
end
