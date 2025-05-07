# frozen_string_literal: true

module Github
  module Repositories
    class FetchListService
      def initialize(client:)
        @client = client
        @allowed_langs = Repository.language.values.to_set(&:downcase)
      end

      def call
        repos = @client.repos.filter_map do |repo|
          lang = repo.language.presence || (repo.fork? && fetch_parent_language(repo))
          repo if lang && @allowed_langs.include?(lang.downcase)
        end

        repos.pluck(:name, :id)
      end

      private

      def fetch_parent_language(repo)
        parent = @client.repository(repo.id).parent
        parent&.language
      end
    end
  end
end
