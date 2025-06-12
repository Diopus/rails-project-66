# frozen_string_literal: true

require 'test_helper'

class Repositories::RubocopParserServiceTest < ActiveSupport::TestCase
  test 'should parse rubocop output' do
    data = load_fixture('files/rubocop_output.json')
    relative_path = 'test'

    service = Repositories::Parser::RubocopParserService.new(data:, relative_path:)
    result = service.call

    column = JSON.parse(data)['files'][1]['offenses'][0]['location']['column']
    line = JSON.parse(data)['files'][1]['offenses'][0]['location']['line']

    assert_equal 2, result.size
    assert_not result[0][:file_path].include?(relative_path)
    assert result[0][:position].include?(column.to_s)
    assert result[0][:position].include?(line.to_s)
  end
end
