# frozen_string_literal: true

module Repositories::Parser
  class RubocopParserService
    def initialize(data:, path:)
      @data = data
      @relative_path = "#{Pathname.new(path).relative_path_from(Rails.root)}/" # rubocop:disable Rails/FilePath
    end

    def call
      json = JSON.parse(@data)
      json['files'].flat_map do |file|
        file_path = file['path'].sub(@relative_path, '')
        file['offenses'].map do |offense|
          line = offense['location']['line']
          column = offense['location']['column']
          {
            file_path:,
            position: "#{line}:#{column}",
            message: offense['message'],
            cop_name: offense['cop_name']
          }
        end
      end
    end
  end
end
