# frozen_string_literal: true

require 'test_helper'

class Repositories::EslintParserServiceTest < ActiveSupport::TestCase
  test 'should parse eslint output' do
    data = load_fixture('files/eslint_output.json')
    path = 'test'

    service = Repositories::Parser::EslintParserService.new(data:, path:)
    result = service.call

    column = JSON.parse(data)[0]['messages'][0]['column']
    line = JSON.parse(data)[0]['messages'][0]['line']

    assert_equal 2, result.size
    assert_not result[0][:file_path].include?(path)
    assert result[0][:position].include?(column.to_s)
    assert result[0][:position].include?(line.to_s)
  end
end
