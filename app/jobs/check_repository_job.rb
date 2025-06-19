# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  rescue_from Repositories::CheckFactory::Error do |exception|
    message = "[CheckJob##{@check.id}] #{exception.class}: #{exception.message}"
    handle_error(message)
  end

  rescue_from StandardError do |exception|
    message = "CheckRepositoryJob failed: #{exception.full_message}"
    handle_error(message)
  end

  def perform(check_id)
    @check = Repository::Check.find_by(id: check_id)
    return unless @check

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
      @check.passed = true
    else
      process_offenses(offenses)
    end

    @check.finish!
  ensure
    Repositories::CleanupService.new(path:).call
  end

  private

  def handle_error(message)
    Rails.logger.error message
    @check&.fail!
    Repository::CheckMailer.with(check: @check, message:).check_failed.deliver_later
  end

  def last_commit_id(repo)
    client = ApplicationContainer[:octokit_client][repo.user.token]

    repo_data = client.repository(repo.github_id)
    branch = repo_data.default_branch
    last_sha = client.commits(repo.github_id, branch).first.sha
    last_sha[0...6]
  end

  def process_offenses(offenses)
    offenses.each do |attrs|
      @check.offenses.create!(attrs)
    end
    offenses_count = offenses.count
    Repository::CheckMailer.with(check: @check, offenses_count:).offenses_found.deliver_later
  end

  def repo_relative_path(repo)
    tmp_root = Rails.application.config.x.repositories_tmp_path
    File.join(tmp_root, repo.github_id.to_s)
  end

  def repo_absolute_path(repo)
    Rails.root.join(repo_relative_path(repo))
  end
end
