# frozen_string_literal: true

module Repositories::Linter
  class EslintLinterService < ShellService
    def initialize(path:) # rubocop:disable Lint/MissingSuper
      @path = path
      @config_path = Rails.root.join(Rails.application.config.x.linters.eslint_config).to_s
    end

    def call
      cmd = "yarn --silent eslint --format json --config #{@config_path} #{@path}"
      stdout, stderr, status = open3.capture3(cmd)

      raise "Eslint error:\n#{stderr}" if status.exitstatus > 1

      [status.exitstatus, stdout]
    end
  end
end
