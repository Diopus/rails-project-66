# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    queue_adapter.perform_enqueued_jobs = true

    @repository_ruby = repositories(:ruby)
    @repository_js = repositories(:js)
    @check_ruby = repository_checks(:ruby)
    @user = users(:one)
  end

  teardown do
    queue_adapter.perform_enqueued_jobs = false
  end

  test 'should show check' do
    sign_in @user

    get repository_check_url @check_ruby.repository, @check_ruby
    assert_response :success
  end

  test 'should not show check when not logged in' do
    get repository_check_url @check_ruby.repository, @check_ruby

    assert_redirected_to root_path
  end

  test 'should create check for Ruby repository' do
    sign_in @user

    assert_difference '@repository_ruby.checks.count', 1 do
      post repository_checks_url @repository_ruby
    end

    assert_redirected_to repository_url(@repository_ruby)
    check = @repository_ruby.checks.last
    assert_performed_with(job: CheckRepositoryJob, args: [check.id])
    assert_equal I18n.t('checks.crud.create.success'), flash[:notice]
    assert check.finished?
  end

  test 'should not create check for another user repository' do
    sign_in @user

    assert_no_difference 'Repository::Check.count' do
      post repository_checks_url @repository_js
    end
    assert_redirected_to root_url
  end
end
