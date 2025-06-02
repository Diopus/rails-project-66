# frozen_string_literal: true

require 'test_helper'
require 'dry/container/stub'

class Repositories::CheckFactoryTest < ActiveSupport::TestCase
  test 'should return [] when linter exit status is zero' do
    # default Open3 stub
    result = default_factory_call(language: 'ruby')
    assert_equal [], result
  end

  test 'should raise UnsupportedLanguageError for unknown lang' do
    assert_raises Repositories::CheckFactory::UnsupportedLanguageError do
      default_factory_call(language: 'turkish')
    end
  end

  test 'should call parser after linter exitstatus == 1' do
    stub_open3_exitstatus(1)

    parser_stub = Minitest::Mock.new
    parser_stub.expect :call, []

    Repositories::Parser::RubocopParserService.stub :new, ->(data:, relative_path:) { parser_stub } do # rubocop:disable Lint/UnusedBlockArgument
      result = default_factory_call(language: 'ruby')
      assert_equal [], result
    end

    parser_stub.verify
    ApplicationContainer.unstub
  end

  test 'should raise LinterError when exit status > 1' do
    stub_open3_exitstatus(2)

    assert_raises Repositories::CheckFactory::LinterError do
      default_factory_call(language: 'ruby')
    end
    ApplicationContainer.unstub
  end

  private

  def default_factory_call(language:, path: '/home/tmp', relative_path: '/tmp')
    Repositories::CheckFactory.call(language:, path:, relative_path:)
  end

  def stub_open3_exitstatus(exitstatus, stdout = '[]')
    # adding custom response we need to stub container's Open3 calls
    open3 = Open3Stub.new
    open3.add_response(/rubocop/, stdout:, exitstatus:)
    ApplicationContainer.enable_stubs!
    ApplicationContainer.stub(:open3, open3)
  end
end
