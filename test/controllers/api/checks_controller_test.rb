# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:ruby)
    @github_id = @repository.github_id
  end

  test 'should create check and return 200 when repo exists' do
    assert_difference '@repository.checks.count', 1 do
      post api_checks_url,
           params: { repository: { id: @github_id }, after: 'push' },
           as: :json
    end

    assert_response :ok
    assert_enqueued_with(job: CheckRepositoryJob, args: [Repository::Check.last.id])
  end

  test 'should not create check but return 422 when repo not found' do
    assert_no_difference 'Repository::Check.count' do
      post api_checks_url,
           params: { repository: { id: 0 }, after: 'push' },
           as: :json
    end
    assert_no_enqueued_jobs
    assert_response :unprocessable_entity
  end
end
