# frozen_string_literal: true

Rails.application.config.x.repositories_tmp_path = ENV.fetch('REPOSITORIES_TMP_PATH', 'tmp/repositories')
