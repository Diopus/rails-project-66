# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get web_repositories_checks_show_url
    assert_response :success
  end

  test 'should get create' do
    get web_repositories_checks_create_url
    assert_response :success
  end
end
