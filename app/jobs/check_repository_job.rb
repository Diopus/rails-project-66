# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  rescue_from Repositories::CheckFactory::Error, with: :handle_factory_error
  rescue_from StandardError, with: :handle_unexpected_error

  def perform(check_id)
    @check = Repository::Check.find(check_id)
    repo = @check.repository
    relative_path = repo_relative_path(repo)
    path = repo_absolute_path(repo)

    # prepare directory
    Repositories::CleanupService.new(path:).call

    # clone repository
    @check.clone_repo!
    @check.commit_id = last_commit_id(repo)
    Repositories::CloneService.new(repo:, path:).call

    # run @check
    @check.check!
    offenses = Repositories::CheckFactory.call(language: repo.language, path:, relative_path:)

    if offenses.empty?
      @check.passed!
    else
      offenses.each do |attrs|
        @check.offenses.create!(attrs)
      end
    end

    @check.finish!
  ensure
    Repositories::CleanupService.new(path:).call
  end

  private

  def handle_factory_error(exception)
    Rails.logger.error "[CheckJob##{@@check.id}] #{exception.class}: #{exception.message}"
    @check.fail!
  end

  def handle_unexpected_error(exception)
    Rails.logger.error("CheckRepositoryJob failed: #{exception.full_message}")
    @check&.fail!
  end

  def last_commit_id(repo)
    client = ApplicationContainer[:octokit_client][repo.user.token]

    repo_data = client.repository(repo.github_id)
    branch = repo_data.default_branch
    last_sha = client.commits(repo.github_id, branch).first.sha
    last_sha[0...6]
  end

  def repo_relative_path(repo)
    tmp_root = Rails.application.config.x.repositories_tmp_path
    File.join(tmp_root, repo.github_id.to_s)
  end

  def repo_absolute_path(repo)
    Rails.root.join(repo_relative_path(repo))
  end
end
