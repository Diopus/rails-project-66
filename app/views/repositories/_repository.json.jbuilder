# frozen_string_literal: true

json.extract! repository, :id, :name, :github_id, :full_name, :language, :clone_url, :ssh_url, :user_id, :created_at, :updated_at
json.url repository_url(repository, format: :json)
