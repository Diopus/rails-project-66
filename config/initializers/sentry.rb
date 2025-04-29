# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://2e50c9d9215df6db31aeee651c446457@o4506713064407040.ingest.us.sentry.io/4509230960279552'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
end
