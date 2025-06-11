# frozen_string_literal: true

require 'test_helper'

class UpdateRepositoryInfoJobTest < ActiveJob::TestCase
  # via octokit_client_stub
  test 'should update language from js to ruby' do
    repo = repositories(:js)
    UpdateRepositoryInfoJob.perform_now(repo.id)

    repo.reload
    assert_equal 'ruby', repo.language
  end

  test 'should update and add webhook for new repo' do
    user = users(:one)
    repo = user.repositories.create(github_id: 3)

    assert_enqueued_with(job: AddWebhookForRepositoryJob, args: [repo.id]) do
      UpdateRepositoryInfoJob.perform_now(repo.id, add_webhook: true)
    end

    repo.reload
    assert repo.language
    assert repo.full_name
    assert_equal 3, repo.github_id
  end
end
