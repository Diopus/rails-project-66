# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find(check_id)

    repo_dir_name = check.repository.github_id.to_s
    relative_path = repo_relative_path(repo_dir_name)
    @path = Rails.root.join(relative_path)

    clean_repositories_directory

    check.commit_id = last_commit_id_in_default_branch(check.repository)

    check.clone_repo!
    @open3 = ApplicationContainer[:open3]
    Github::Repositories::CloneService.new(repository: check.repository, path: @path, open3: @open3).call

    check.check!
    config_path = Rails.root.join('config/linters/rubocop.yml').to_s
    Github::Repositories::Linter::RubocopService.new(path: @path, open3: @open3, config_path:).call

    check.finish!
  rescue StandardError => e
    Rails.logger.error("CheckRepositoryJob failed: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    check.fail!
  ensure
    # clean_repositories_directory

    unless check.finished?
      check.fail!
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

  def repo_relative_path(repo_dir_name)
    tmp_path = Rails.application.config.x.repositories_tmp_path
    [tmp_path, repo_dir_name].join('/')
  end
end
