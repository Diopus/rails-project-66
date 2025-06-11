# frozen_string_literal: true

require 'test_helper'

class Repositories::AddWebhookServiceTest < ActiveSupport::TestCase
  test 'should not create hook when hooks exists' do
    # standard octokit_client_stub where .hooks returns non-empty array
    repo = repositories(:ruby)
    client = OctokitClientStub.new

    service = Repositories::AddWebhookService.new(repository: repo, client: client)

    assert_not service.call
  end

  test 'should create hook when no hooks existing' do
    repo = repositories(:ruby)
    client = OctokitClientStub.new

    def client.hooks(_repo_full_name)
      []
    end

    service = Repositories::AddWebhookService.new(repository: repo, client: client)

    assert service.call
  end
end
