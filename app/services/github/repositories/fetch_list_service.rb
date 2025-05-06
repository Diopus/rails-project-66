module Github
  module Repositories
    class FetchListService
      def initialize(client:)
        @client = client
      end

      def call
        @client.repos.pluck(:name, :id)
      end
    end
  end
end
