# frozen_string_literal: true

module Repositories
  class CheckFactory
    LINTERS = {
      'ruby' => Linter::RubocopLinterService,
      'javascript' => Linter::EslintLinterService
    }.freeze

    PARSERS = {
      'ruby' => Parser::RubocopParserService,
      'javascript' => Parser::EslintParserService
    }.freeze

    class Error < StandardError; end
    class UnsupportedLanguageError < Error; end
    class LinterError < Error; end

    def self.call(language:, path:)
      raise UnsupportedLanguageError, "Unsupported language `#{language}`" unless LINTERS.key?(language.to_s.downcase)

      key = language.to_s.downcase

      # linter
      linter = LINTERS[key]

      begin
        status, data = linter.new(path:).call
      rescue StandardError => e
        raise LinterError, e.message
      end

      return [] if status.zero?

      # parser
      parser = PARSERS[key]

      parser.new(data:, path:).call
    end
  end
end
