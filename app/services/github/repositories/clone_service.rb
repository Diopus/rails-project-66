# frozen_string_literal: true

module Github
  module Repositories
    class CloneService
      def initialize(repository:, path:, open3:)
        @repository = repository
        @path = path
        @open3 = open3
      end

      def call
        cmd = "git clone #{@repository.clone_url} #{@path}"
        output, status = @open3.capture2e(cmd)

        return if status.success?

        raise "git clone error:\n#{output}"

        # @open3.popen3(cmd) do |_stdin, _stdout, stderr, wait_thr|
        #   unless wait_thr.value.success?
        #     raise "Error: #{stderr.read}"
        #   end
        # end
      end
    end
  end
end
