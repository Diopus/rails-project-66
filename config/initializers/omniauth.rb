# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    provider :developer
    github_client_id = GITHUB_CLIENT_ID_DEV
    github_client_secret = GITHUB_CLIENT_SECRET_DEV
  else
    github_client_id = GITHUB_CLIENT_ID
    github_client_secret = GITHUB_CLIENT_SECRET
  end

  provider :github, ENV.fetch(github_client_id, nil), ENV.fetch(github_client_secret, nil), scope: 'user'
end
