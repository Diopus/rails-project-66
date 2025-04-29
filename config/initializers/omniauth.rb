# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    provider :developer
    github_client_id_var = 'GITHUB_CLIENT_ID_DEV'
    github_client_secret_var = 'GITHUB_CLIENT_SECRET_DEV'
  else
    github_client_id_var = 'GITHUB_CLIENT_ID'
    github_client_secret_var = 'GITHUB_CLIENT_SECRET'
  end

  provider :github, ENV.fetch(github_client_id_var, nil), ENV.fetch(github_client_secret_var, nil), scope: 'user,public_repo,admin:repo_hook'
end
