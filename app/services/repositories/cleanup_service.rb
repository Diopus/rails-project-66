# frozen_string_literal: true

module Repositories
  class CleanupService
    def initialize(path:)
      @path = path
    end

    def call
      FileUtils.rm_rf(@path) if @path
    end
  end
end
