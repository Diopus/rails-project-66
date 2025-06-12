# frozen_string_literal: true

require 'test_helper'

class Repositories::FetchInfoServiceTest < ActiveSupport::TestCase
  test 'should send request and return repository_data' do
    repo = repositories(:ruby)
    repo_gh_id = repo.github_id
    stub_link = "https://api.github.com/repositories/#{repo_gh_id}"
    response_json = load_fixture('files/github_repo_info_reply.json')

    stub_request(:get, stub_link)
      .to_return(
        body: response_json,
        status: 200,
        headers: { content_type: 'application/json; charset=utf-8' }
      )

    client = Octokit::Client.new
    service = Repositories::FetchInfoService.new(repository: repo, client: client)
    repository_data = service.call

    assert_equal JSON.parse(response_json)['name'], repository_data[:name]
  end
end
