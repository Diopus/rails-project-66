# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    @check = Repository::Check.find(check_id)
    @path = Rails.root.join('tmp', 'repositories', @check.repository.github_id.to_s)

    clean_repositories_directory

    check.commit_id = last_commit_id_in_default_branch(check.repository)

    check.clone_repo!
    @open3 = ApplicationContainer[:open3]
    Github::Repositories::CloneService.new(repository: @check.repository, path:, open3:).call

    check.check!
    config_path = Rails.root.join('config/linters/rubocop.yml').to_s
    Github::Repositories::Linter::RubocopService.new(path: @path, open3: @open3, config_path:).call

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

  private

  def clean_repositories_directory
    FileUtils.rm_rf(@path) if @path && Dir.exist?(@path)
  end

  def last_commit_id_in_default_branch(repo)
    client = ApplicationContainer[:octokit_client][repo.user.token]

    repo_data = client.repository(repo.github_id)
    branch = repo_data.default_branch
    last_sha = client.commits(repo.github_id, branch).first.sha
    last_sha[0...6]
  end
end
