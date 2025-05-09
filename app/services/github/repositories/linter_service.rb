# frozen_string_literal: true

module Github
  module Repositories
    class LinterService
      def initialize(check:)
        @check = check
      end

      def call; end
    end
  end
end
