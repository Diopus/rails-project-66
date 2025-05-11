# frozen_string_literal: true

module Github::Repositories::Linter
  class RubocopService
    def initialize(path:, open3:, config_path:)
      @path = path
      @config_path = config_path
      @open3 = open3
    end

    def call
      cmd = "bundle exec rubocop --format json --config #{@config_path} #{@path}"
      stdout, stderr, status = @open3.capture3(cmd)

      unless status.success?
        raise "RuboCop error:\n#{stderr}"
      end

      JSON.parse(stdout)
    end
  end
end
