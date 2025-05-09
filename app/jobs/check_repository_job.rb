# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    @check = Repository::Check.find(check_id)
    @path = Rails.root.join('tmp', 'repositories', @check.repository.github_id.to_s)

    clean_repositories_directory

    @check.clone_repo!
    @open3 = ApplicationContainer[:open3]
    Github::Repositories::CloneService.new(repository: @check.repository, path:, open3:).call

    # @check.check!
    # Github::Repositories::LinterService.new(check:).call

    @check.finish!
  rescue StandardError => e
    Rails.logger.error("CheckRepositoryJob failed: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    @check.fail!
  ensure
    # Clean up the cloned repository
    clean_repositories_directory

    # Ensure the check is marked as failed if it was not finished successfully
    unless @check.finished?
      @check.fail!
    end
  end

  def clean_repositories_directory
    FileUtils.rm_rf(@path) if @path && Dir.exist?(@path)
  end
end
