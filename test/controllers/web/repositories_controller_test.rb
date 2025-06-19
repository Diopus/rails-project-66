# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    queue_adapter.perform_enqueued_jobs = true

    @repository = repositories(:ruby)
    @repository_other = repositories(:js)
    @user = users(:one)
  end

  teardown do
    queue_adapter.perform_enqueued_jobs = false
  end

  test 'should not get index when not logged in' do
    get repositories_url
    assert_redirected_to root_path
  end

  test "should get only user's repositories on index" do
    sign_in @user

    get repositories_url

    assert_select 'table tbody tr', 1
    assert_select 'td', text: @repository.name
    assert_select 'td', text: @repository_other.name, count: 0
  end

  test 'should get new and prepare repositories_list' do
    sign_in @user

    fake_list = [['foo', 1], ['bar', 2]]

    # Stub the service to return a fake list
    service_stub = Struct.new(:call).new(fake_list)
    ::Repositories::FetchListService.stub :new, ->(client:) { service_stub } do # rubocop:disable Lint/UnusedBlockArgument
      get new_repository_path
    end

    assert_response :success
    assert_select "select[name='repository[github_id]'] option", count: (fake_list.size + 1)
  end

  test 'should not create repository if exists but should run update job' do
    sign_in @user

    assert_no_difference 'Repository.count' do
      post repositories_url, params: { repository: { github_id: @repository.github_id } }
    end

    assert_redirected_to repositories_path
    assert_equal I18n.t('repositories.crud.create.exists'), flash[:warning]
  end

  test 'should create new repository' do
    sign_in @user

    github_id = Faker::Number.number(digits: 9)

    post repositories_url, params: { repository: { github_id: github_id } }

    new_repo = Repository.find_by(github_id: github_id)
    assert new_repo.present?
    assert_redirected_to repositories_path
    assert_equal I18n.t('repositories.crud.create.success'), flash[:notice]
    assert_performed_with(job: UpdateRepositoryInfoJob, args: [new_repo.id, { add_webhook: true }])
    assert_equal new_repo.ssh_url, 'git@github.com:test/test.git'
  end

  test 'should not create repository with invalid data' do
    sign_in @user

    assert_no_difference 'Repository.count' do
      post repositories_url, params: { repository: { github_id: nil } }
    end

    assert_response :unprocessable_entity
    assert_equal I18n.t('repositories.crud.create.failure'), flash[:alert]
  end

  test 'should not show when not logged it' do
    get repository_url(@repository_other)
    assert_redirected_to root_path
  end

  test 'should show own repository' do
    sign_in @user

    get repository_url(@repository)
    assert_response :success
  end
end
