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

    def self.call(language:, path:, relative_path:)
      raise UnsupportedLanguageError, "Unsupported language `#{language}`" unless LINTERS.key?(language.to_s.downcase)

      key = language.to_s.downcase

      # linter
      linter = LINTERS[key] or
        raise UnsupportedLanguageError, "No linter defined for language `#{language}`"
      status, data = linter.new(path:).call

      raise LinterError, "Linter failed with exit #{status}" if status > 1
      return [] if status.zero?

      # parser
      parser = PARSERS[key] or
        raise UnsupportedLanguageError, "No parser defined for language `#{language}`"
      parser.new(data:, relative_path:).call
    end
  end
end
