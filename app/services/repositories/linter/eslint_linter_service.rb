# frozen_string_literal: true

module Repositories::Linter
  class EslintLinterService
    def initialize(path:)
      @path = path
      @config_path = Rails.root.join(Rails.application.config.x.linters.eslint_config).to_s
    end

    def call
      open3 = ApplicationContainer[:open3]
      cmd = "yarn --silent eslint --format json --config #{@config_path} #{@path}"
      stdout, stderr, status = open3.capture3(cmd)

      raise "Eslint error:\n#{stderr}" if status.exitstatus > 1

      [status.exitstatus, stdout]
    end
  end
end
