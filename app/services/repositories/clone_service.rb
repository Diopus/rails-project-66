# frozen_string_literal: true

module Repositories
  class CloneService < ShellService
    def initialize(repo:, path:) # rubocop:disable Lint/MissingSuper
      @repo = repo
      @path = path
    end

    def call
      cmd = "git clone #{@repo.clone_url} #{@path}"
      output, status = open3.capture2e(cmd)

      return if status.exitstatus.zero?

      raise "git clone error:\n#{output}"
    end
  end
end
