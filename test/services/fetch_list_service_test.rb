# frozen_string_literal: true

require 'test_helper'

class Repositories::FetchListServiceTest < ActiveSupport::TestCase
  test 'should send request and return list of repos' do
    stub_link = 'https://api.github.com/user/repos'
    response_json = load_fixture('files/github_repo_list_reply.json')

    stub_request(:get, stub_link)
      .to_return(
        body: response_json,
        status: 200,
        headers: { content_type: 'application/json; charset=utf-8' }
      )

    client = Octokit::Client.new
    service = Repositories::FetchListService.new(client: client)
    repos = service.call

    assert_equal repos.count + 1, JSON.parse(response_json).count
  end
end
