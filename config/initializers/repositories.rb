# frozen_string_literal: true

Rails.application.config.x.repositories_tmp_path = ENV.fetch('REPOSITORIES_TMP_PATH', 'tmp/repositories')
Rails.application.config.x.linters.rubocop_config = 'config/linters/rubocop.yml'
Rails.application.config.x.linters.eslint_config = 'config/linters/eslint.config.mjs'
