# frozen_string_literal: true

require 'test_helper'

class AddWebhookForRepositoryJobTest < ActiveJob::TestCase
  test 'should call AddWebhookService with correct arguments' do
    user = users(:one)
    repo = user.repositories.create!(
      github_id: 3,
      full_name: 'test/repo',
      language: 'ruby'
    )

    webhooker = Minitest::Mock.new
    webhooker.expect :call, nil

    Repositories::AddWebhookService.stub :new, ->(repository:, client:) { webhooker } do # rubocop:disable Lint/UnusedBlockArgument
      AddWebhookForRepositoryJob.perform_now(repo.id)
    end

    assert true
    webhooker.verify
  end
end
