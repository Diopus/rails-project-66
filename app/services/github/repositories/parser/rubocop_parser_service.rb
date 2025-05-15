# frozen_string_literal: true

module Github::Repositories::Parser
  class RubocopParserService
    def initialize(check:, relative_path:, report:)
      @check = check
      @relative_path = "#{relative_path}/"
      @report = report
    end

    def call
      json = JSON.parse(@report)
      json['files'].each do |file|
        file_path = file['path'].sub(@relative_path, '')
        file['offenses'].each do |offense|
          line = offense['location']['line']
          column = offense['location']['column']
          message = offense['message']
          cop_name = offense['cop_name']

          @check.offenses.create!(
            file_path:,
            position: "#{line}:#{column}",
            message:,
            cop_name:
          )
        end
      end
    end
  end
end
