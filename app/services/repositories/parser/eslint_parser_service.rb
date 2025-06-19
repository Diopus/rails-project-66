# frozen_string_literal: true

module Repositories::Parser
  class EslintParserService
    def initialize(data:, path:)
      @data = data
      @path = "#{path}/"
    end

    def call
      json = JSON.parse(@data)
      json.flat_map do |file|
        file_path = file['filePath'].sub(@path, '')
        file['messages'].map do |offense|
          line = offense['line']
          column = offense['column']
          {
            file_path:,
            position: "#{line}:#{column}",
            message: offense['message'],
            cop_name: offense['ruleId']
          }
        end
      end
    end
  end
end
